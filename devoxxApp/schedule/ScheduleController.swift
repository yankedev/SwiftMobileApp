//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, DevoxxAppScheduleDelegate {

    var seg : UISegmentedControl!
    var pageView : UIPageViewController?
    var viewControllers = [UIViewController]()
    var a:UIViewController!
    
    var heightConstant:CGFloat!
    var constW:[NSLayoutConstraint]!
    
    func initPageViewController() {
        pageView = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        //pageView!.view.frame = CGRectMake(0,(self.navigationController?.navigationBar.frame.size.height)!,380,575)
        pageView?.dataSource = self
        pageView?.delegate = self
        pageView?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.view.addSubview(pageView!.view)
        self.view.backgroundColor = ColorManager.bottomDotsPageController
        
        pageView!.view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["pageView": pageView!.view]
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|", options: .AlignAllCenterY, metrics: nil, views: views)
        view.addConstraints(constH)
        
        heightConstant = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
        
        constW = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[pageView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        view.addConstraints(constW)

        
        
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
        return a.view.tag
    }
    

    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
   
    public func configure() {
        a = UIViewController()
        let childViewController = SchedulerTableViewController()
        childViewController.delegate = self
        viewControllers = [childViewController]
        print("set current in configure")
        initPageViewController()
        a.view.tag = 0
        //pageView!.addChildViewController(childViewController)
    }
    
    

    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag as Int
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
        var index = viewController.view.tag as Int
        if(index == 0  || index == NSNotFound) {
            return nil
        }
        index--
        
        return viewControllerAtIndex(index)
    }
    
    public func viewControllerAtIndex(index : NSInteger) -> SchedulerTableViewController {
        let child = SchedulerTableViewController()
        child.delegate = self
        child.view.tag = index
        print("set current in viewControllerAtIndex")
        return child
    }
    
    
    public func changeSchedule(seg : UISegmentedControl) {
        let aa = pageView!.viewControllers![0] as! SchedulerTableViewController
        aa.changeSchedule(isMySchedule : (seg.selectedSegmentIndex == 1))
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed) {
            return
        }
        let aa = pageViewController.viewControllers![0] as! SchedulerTableViewController
        print(aa.view.tag)
    }
    
    public func isMySheduleSelected() -> Bool {
        return (seg.selectedSegmentIndex == 1)
    }
    
    public func getNavigationController() -> UINavigationController? {
        return navigationController
    }

    public override func viewDidLayoutSubviews() {
        let views = ["pageView": pageView!.view]
        heightConstant = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
        view.removeConstraints(constW)
        constW = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[pageView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        view.addConstraints(constW)

        
    }
}

