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


open class TrackController<T : ScrollableDateProtocol> : HuntlyNavigationController, ScrollableDateTableDatasource, ScrollableDateTableDelegate {
    
    
    
    //ScrollableDateTableDatasource
    weak var scrollableDateTableDatasource: ScrollableDateTableDatasource?
    weak var scrollableDateTableDelegate: ScrollableDateTableDelegate?
    
    var allTracks:[Attribute]?
    
    var allDates:NSArray!
    
    var pageViewController : UIPageViewController!
    
    
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
        
        customView = ScheduleControllerView()
        
        
        
        feedDate()
        
        self.scrollableDateTableDatasource = self
        self.scrollableDateTableDelegate = self
        
        
        self.navigationBar.isTranslucent = false
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        self.pageViewController.navigationItem.leftBarButtonItem = huntlyLeftButton
        
        self.view.addSubview(customView!)
        
        
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
        
        
        if currentIndex == allTracks?.count {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    open func viewControllerAtIndex(_ index : NSInteger) -> UIViewController {
        
        let scheduleTableController = T()
        scheduleTableController.index = index
        
        if let tracks = self.scrollableDateTableDatasource?.allTracks {
            scheduleTableController.currentTrack = tracks[index].objectID
        }
        return (scheduleTableController as? UIViewController)!
    }
    
    
    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        if let tracks = self.scrollableDateTableDatasource?.allTracks {
            return tracks.count
        }
        return 0
    }
    
    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
    
    func updateTitle() {
        if allTracks?.count == 0 {
            self.pageViewController.navigationItem.title = NSLocalizedString("No data", comment: "")
        }
        else {
            self.pageViewController.navigationItem.title = NSLocalizedString("Tracks", comment: "")
        }
    }
    
    func callBack(_ attributes : [Attribute], error : AttributeStoreError?) {
        allTracks = attributes
        updateTitle()
        
        let demo = viewControllerAtIndex(0)
        let controls = [demo]
        pageViewController?.setViewControllers(controls, direction: .forward, animated: false, completion: nil)
        pushViewController(pageViewController!, animated: false)
        
    }
    
    //ScrollableDateTableDelegate
    func feedDate() {
        AttributeService.sharedInstance.fetchTracks(callBack)
    }
    
    
    
    func humanReadableDateFromNSDate(_ date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
    
    
}

