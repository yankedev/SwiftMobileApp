//
//  TrackController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-09.
//  Copyright © 2016 maximedavid. All rights reserved.
//

//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit





public class TrackController<T : ScrollableDateProtocol> : UINavigationController, DevoxxAppFilter, ScrollableDateTableDatasource, ScrollableDateTableDelegate {
    
    var generator: () -> ScrollableDateProtocol
    
    //ScrollableDateTableDatasource
    var scrollableDateTableDatasource: ScrollableDateTableDatasource?
    var scrollableDateTableDelegate: ScrollableDateTableDelegate?
    
    var allTracks:NSArray!

    var allDates:NSArray!

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
        
        
        
        
        
        
        
        if allTracks.count == 0 {
            self.pageViewController.navigationItem.title = "No data yet"
        }
        else {
            self.pageViewController.navigationItem.title = "Tracks"        }
        
        
        
        
        self.view.addSubview(customView!)
        
        
    }
    
    
    
    
    func filter(filters : [String: [FilterableProtocol]]) -> Void {
        
        
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
        
        
        if currentIndex == allTracks.count {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    public func viewControllerAtIndex(index : NSInteger) -> UIViewController {
        
        let scheduleTableController:T = generator() as! T
        scheduleTableController.index = index
        
        if let tracks = self.scrollableDateTableDatasource?.allTracks {
            scheduleTableController.currentTrack = APIManager.getTrackFromIndex(index, array: tracks)
            
            
            
        }
        return (scheduleTableController as? UIViewController)!
    }
    
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let tracks = self.scrollableDateTableDatasource?.allTracks {
            return tracks.count
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
                
                
               
                
                
                if let reloadable = pageViewController.viewControllers![0] as? HotReloadProtocol {
                    reloadable.fetchUpdate()
                }
                
                
                
            }
        }
        
    }
    
    
    //ScrollableDateTableDelegate
    func feedDate() {
        allTracks = APIManager.getDistinctTracks()
    }
    
    func humanReadableDateFromNSDate(date : NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        return dateFormatter.stringFromDate(date)
    }
    
    
}

