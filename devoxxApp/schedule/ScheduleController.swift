//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var seg : UISegmentedControl!

    var pageView : UIPageViewController?
    var viewControllers = [UIViewController]()
    var currentController : SchedulerTableViewController!
    var globalIndex = 0
    
    var a:CustomViewController!
    
    func initPageViewController() {
        pageView = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageView!.view.frame = CGRectMake(0,(self.navigationController?.navigationBar.frame.size.height)!,380,575)
        pageView?.dataSource = self
        pageView?.delegate = self
        pageView?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.view.addSubview(pageView!.view)
        self.view.backgroundColor = ColorManager.bottomDotsPageController
    }
    
    override public func viewDidLoad() {
        seg = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
        seg.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        seg.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        seg.selectedSegmentIndex = 0
        seg.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView = seg
        seg.addTarget(self, action: Selector("changeSchedule:"), forControlEvents: .ValueChanged)
        configure()
    }
    
    
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return a.index
    }
    

    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
   
    public func configure() {
        a = CustomViewController()
        viewControllers = [a]
        print("set current in configure")
        currentController = a.childTableController
        initPageViewController()
    }
    
    

    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var contentView = viewController as! CustomViewController
        var index = contentView.index as Int
        globalIndex = index
        if(index == NSNotFound) {
            return nil
        }
        index++
        if (index == 5) {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var contentView = viewController as! CustomViewController
        var index = contentView.index as Int
        globalIndex = index
        if(index == 0  || index == NSNotFound) {
            return nil
        }
        index--
        
        return viewControllerAtIndex(index)
    }
    
    public func viewControllerAtIndex(index : NSInteger) -> CustomViewController {
        let child = CustomViewController()
        child.index = index
        seg.tag = index
        print("set current in viewControllerAtIndex")
        currentController = child.childTableController
        return child
    }
    
    
    public func changeSchedule(seg : UISegmentedControl) {
        let aa = pageView!.viewControllers![0] as! CustomViewController
        aa.childTableController.changeSchedule(isMySchedule : (seg.selectedSegmentIndex == 1))
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed) {
            return
        }
        let aa = pageViewController.viewControllers![0] as! CustomViewController
        print(aa.childTableController.index)
    }

    
}

