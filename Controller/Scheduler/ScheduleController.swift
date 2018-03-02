//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public protocol ScrollableDateProtocol : NSObjectProtocol {
    var index:Int { get set }
    var currentDate:Date!  { get set }
    var currentTrack:NSManagedObjectID!  { get set }
    func getNavigationItem() -> UINavigationItem
    init()
}



open class ScheduleController<T : ScrollableDateProtocol> : HuntlyNavigationController, DevoxxAppFilter, ScrollableDateTableDatasource, ScrollableDateTableDelegate {
    
    
    
    //ScrollableDateTableDatasource
    weak var scrollableDateTableDatasource: ScrollableDateTableDatasource?
    weak var scrollableDateTableDelegate: ScrollableDateTableDelegate?
    
    var allDates:NSArray!
    var allTracks:[Attribute]?
    var pageViewController : UIPageViewController!
    
    
    var overlay:FilterTableViewController?
    
    
    
    var customView:ScheduleControllerView?
   
    init() {
        super.init(navigationBarClass: nil, toolbarClass: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
      
        
        
        customView = ScheduleControllerView(target: self, filterSelector: #selector(self.filterMe))
        
       
        
        feedDate()
        
        
    }
    
    
    
    
    func filter(_ filters : [String: [FilterableProtocol]]) -> Void {
        
        
        if filters.count == 0 {
            customView?.filterRightButton.image = UIImage(named: "ic_filter_inactive")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
        else {
            customView?.filterRightButton.image = UIImage(named: "ic_filter_active")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
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
    
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        feedDate()
    }
    
    
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? T {
            currentIndex = demoController.index
        }
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return viewControllerAtIndex(currentIndex)
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? T {
            currentIndex = demoController.index
        }
        
        currentIndex += 1
        
        
        if currentIndex == allDates.count {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    open func viewControllerAtIndex(_ index : NSInteger) -> UIViewController {
        
        let scheduleTableController:T = T()
        scheduleTableController.index = index
        
        if let dates = self.scrollableDateTableDatasource?.allDates {
            
            scheduleTableController.currentDate = APIManager.getDateFromIndex(index, array: dates)
            
            
            
        }
        return (scheduleTableController as? UIViewController)!
    }
    
    
    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        if let dates = self.scrollableDateTableDatasource?.allDates {
            return dates.count
        }
        return 0
    }
    
    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
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
        SlotService.sharedInstance.fetchCfpDay(callBack)
    }
    
    func callBack(_ slots: NSArray, error: SlotStoreError?) {
        allDates = slots
        
        
        
        
        self.scrollableDateTableDatasource = self
        self.scrollableDateTableDelegate = self
        
        
        self.navigationBar.isTranslucent = false
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        self.pageViewController.navigationItem.leftBarButtonItem = huntlyLeftButton
        
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        let demo = viewControllerAtIndex(0)
        
        let controls = [demo]
        
        pageViewController?.setViewControllers(controls, direction: .forward, animated: false, completion: nil)
        
        pushViewController(pageViewController!, animated: false)
        
        
        
        
        self.pageViewController.navigationItem.rightBarButtonItem = customView!.filterRightButton
        
        
        if allDates.count == 0 {
            self.pageViewController.navigationItem.title = "No data yet"
        }
        else {
            self.pageViewController.navigationItem.title = humanReadableDateFromNSDate((allDates[0] as AnyObject).object(forKey: "date") as! Date)
        }
        
        self.view.addSubview(customView!)
        
        
    }
    
    func humanReadableDateFromNSDate(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
    
  
    
}
