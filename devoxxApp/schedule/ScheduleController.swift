//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit


public protocol ScrollableDateProtocol : NSObjectProtocol {
    var index:Int { get set }
    var currentDate:NSDate!  { get set }
    var currentTrack:String!  { get set }
    func getNavigationItem() -> UINavigationItem
}



public class ScheduleController<T : ScrollableDateProtocol> : UINavigationController, DevoxxAppFilter, ScrollableDateTableDatasource, ScrollableDateTableDelegate {

    var generator: () -> ScrollableDateProtocol
    
    //ScrollableDateTableDatasource
    var scrollableDateTableDatasource: ScrollableDateTableDatasource?
    var scrollableDateTableDelegate: ScrollableDateTableDelegate?
    
    var allDates:NSArray!
    var allTracks:NSArray!
    var pageViewController : UIPageViewController!
    
    
    var overlay:FilterTableViewController?
    
    
    
    var customView:ScheduleControllerView?
    
    init(generator: () -> ScrollableDateProtocol) {
        self.generator = generator
        super.init(navigationBarClass: nil, toolbarClass: nil)
    }

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()

        customView = ScheduleControllerView(target: self, filterSelector: Selector("filterMe"), favoriteSelector : Selector("changeSchedule:"))

        
        
        feedDate()
        
        self.scrollableDateTableDatasource = self
        self.scrollableDateTableDelegate = self
    

        self.navigationBar.translucent = false
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        let demo = viewControllerAtIndex(0)
        let controls = [demo]
        
        pageViewController?.setViewControllers(controls, direction: .Forward, animated: false, completion: nil)
        
        pushViewController(pageViewController!, animated: false)

        
        //self.pageViewController.navigationItem.rightBarButtonItems = [customView!.filterRightButton, customView!.favoriteSwitcher]
        self.pageViewController.navigationItem.rightBarButtonItem = customView!.filterRightButton
  
        
        
        
        
             
        
        if allDates.count == 0 {
            self.pageViewController.navigationItem.title = "No data yet"
        }
        else {
            self.pageViewController.navigationItem.title = humanReadableDateFromNSDate(allDates[0].objectForKey("date") as! NSDate)
        }
        
       
        
      
        self.view.addSubview(customView!)
        

    }
    
    
 
    
    func filter(filters : [String: [FilterableProtocol]]) -> Void {
        
        
        if filters.count == 0 {
            customView?.filterRightButton.image = UIImage(named: "ic_filter_inactive")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        else {
            customView?.filterRightButton.image = UIImage(named: "ic_filter_active")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        
        
        if pageViewController != nil && pageViewController!.viewControllers != nil{
            if let filterableTable = pageViewController!.viewControllers![0] as? FilterableTableProtocol {
                
                filterableTable.clearFilter()
                filterableTable.buildFilter(filters)
                filterableTable.filter()
            }
        }
    }

    
    func filterMe() {
        if pageViewController != nil && pageViewController!.viewControllers != nil{
            
            
            if overlay == nil {
                
                overlay = FilterTableViewController()
                
                overlay?.viewDidLoad()
                
           
                
                
                
               
                //
                
                if pageViewController != nil && pageViewController!.viewControllers != nil{
                    if let filterableTable = pageViewController!.viewControllers![0] as? FilterableTableProtocol {
                        if filterableTable.getCurrentFilters() != nil {
                            overlay?.selected = filterableTable.getCurrentFilters()!
                        }
                                            }
                }
                
                
                //
                
                pageViewController!.viewControllers![0].view.addSubview((overlay?.filterTableView)!)
                
                overlay?.filterTableView.setupConstraints(referenceView : pageViewController!.viewControllers![0].view)
                
                
              
            
                overlay?.devoxxAppFilterDelegate = self
            
            
         

            }
            else {
                removeOverlay()
            }
        
        }
    }
    
    func removeOverlay() {
        overlay?.filterTableView.removeFromSuperview()
        overlay = nil
    }
    
    func changeSchedule(sender : UIBarButtonItem) {
        sender.tag == (sender.tag + 1) % 2
    }

    
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? T {
            currentIndex = demoController.index
        }
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex--
    
        return viewControllerAtIndex(currentIndex)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? T {
            currentIndex = demoController.index
        }
        
        currentIndex++
        
        
        if currentIndex == allDates.count {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    public func viewControllerAtIndex(index : NSInteger) -> UIViewController {
        
        let scheduleTableController:T = generator() as! T
        scheduleTableController.index = index
        
        if let dates = self.scrollableDateTableDatasource?.allDates {
            scheduleTableController.currentDate = APIManager.getDateFromIndex(index, array: dates)
            
            
        
        }
        return (scheduleTableController as? UIViewController)!
    }
    
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let dates = self.scrollableDateTableDatasource?.allDates {
            return dates.count
        }
        return 0
    }
    
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            removeOverlay()
            if pageViewController.viewControllers != nil {
                
               
                if let fav = pageViewController.viewControllers![0] as? ScrollableDateProtocol {
                    self.pageViewController.navigationItem.title = humanReadableDateFromNSDate(fav.currentDate)
                }

                
                if let reloadable = pageViewController.viewControllers![0] as? HotReloadProtocol {
                    reloadable.fetchUpdate()
                }

                
                
            }
        }
        
    }
    

    //ScrollableDateTableDelegate
    func feedDate() {
        allDates = APIManager.getDistinctDays()
    }
    
    func humanReadableDateFromNSDate(date : NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        return dateFormatter.stringFromDate(date)
    }
    
   
}
