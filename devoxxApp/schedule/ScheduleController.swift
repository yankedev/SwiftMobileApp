//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, DevoxxAppScheduleDelegate, DevoxxAppFilter {
    
    var seg : UISegmentedControl!
    var pageView : UIPageViewController?
    var viewControllers = [UIViewController]()
    var a:UIViewController!
    
    //var heightConstant:CGFloat!
    //var constW:[NSLayoutConstraint]!
    //var constW2:[NSLayoutConstraint]!
    
    //var constH:[NSLayoutConstraint]!
    
    
    var t = FilterTableViewController()
    
    func initPageViewController() {
        pageView = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        //pageView!.view.frame = CGRectMake(0,(self.navigationController?.navigationBar.frame.size.height)!,380,575)
        pageView?.dataSource = self
        pageView?.delegate = self
        pageView?.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.view.addSubview(pageView!.view)
        self.view.backgroundColor = ColorManager.bottomDotsPageController
        
        //pageView!.view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["pageView": pageView!.view, "filterView" : t.tableView]
        
        //constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[pageView]|", options: .AlignAllCenterY, metrics: nil, views: views)
        //view.addConstraints(constH)
        
        
        
        //heightConstant = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
        
        //constW = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[pageView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        //constW2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[filterView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        //view.addConstraints(constW)
        //view.addConstraints(constW2)
        
        
        
    }
    
    
    
    func completionMethod(isFinished:Bool) {
        if(isFinished) {
            //menuView.removeFromSuperview()
            let finalCenter = CGPointMake(t.tableView.center.x + t.tableView.frame.width, t.tableView.center.y)
            t.tableView.center = finalCenter
        }
    }
    
    func filterMe() {
        print("FILTERME")
        let views = ["pageView": pageView!.view, "filterView" : t.tableView]
        if view.tag == 0 {
            view.tag = 1
            //view.removeConstraints(constH)
            
            
            
            
            //constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[filterView(100)]-[pageView]|", options: .AlignAllCenterY, metrics: nil, views: views)
            
            UIView.animateWithDuration(0.5) {
                self.view.layoutIfNeeded()
            }
            
            
        }
        else {
            
            
            /*
            view.removeConstraints(constH)
            constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[filterView(0)]-[pageView]|", options: .AlignAllCenterY, metrics: nil, views: views)
            view.addConstraints(constH)
            */
            
            
            view.tag = 0
        }
        
        
        
        
    }
    
    override public func viewDidLoad() {
        /*(seg = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
        seg.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        seg.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        seg.selectedSegmentIndex = 0
        seg.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView = seg
        
        let filterRightButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: Selector("filterMe"))
        navigationItem.rightBarButtonItem = filterRightButton
        
        
        seg.addTarget(self, action: Selector("changeSchedule:"), forControlEvents: .ValueChanged)
        
        
        view.addSubview(t.tableView)
        t.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        */
        configure()
        
        
        
        //t.delegate = self
        
        
        
        
        
        
        
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        
        print(self.view.frame)
        
        
        view.tag = 0
        
        
        
        
        
        
        
        
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
        
        print("set current in configure")
        
        let views = ["pageView": childViewController.tableView]
        
       
        
              a.view.tag = 0
        
    
    
        let nc = UINavigationController(rootViewController: childViewController)
        viewControllers = [nc]
        initPageViewController()
        
        pageView?.addChildViewController(nc)
        
      
        childViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        print(childViewController.tableView)
        print(childViewController.view)
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|", options: .AlignAllCenterY, metrics: nil, views: views)
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[pageView]|", options: .AlignAllCenterX, metrics: nil, views: views)
       
        
        childViewController.view.addConstraints(constH)
        childViewController.view.addConstraints(constV)
        
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
    
    public func viewControllerAtIndex(index : NSInteger) -> UINavigationController {
        let childViewController = SchedulerTableViewController()
        childViewController.delegate = self
        childViewController.view.tag = index
        
        print("set current in viewControllerAtIndex \(index)")
        let nc = UINavigationController(rootViewController: childViewController)
        pageView?.addChildViewController(nc)
        return nc
    }
    
    
    public func changeSchedule(seg : UISegmentedControl) {
        let aa = pageView!.viewControllers![0] as! SchedulerTableViewController
        aa.changeSchedule(isMySchedule : (seg.selectedSegmentIndex == 1))
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(!completed) {
            return
        }
        //let aa = pageViewController.viewControllers![0] as! SchedulerTableViewController
        //print(aa.view.tag)
    }
    
    public func isMySheduleSelected() -> Bool {
        return false
        //return (seg.selectedSegmentIndex == 1)
    }
    
    public func getNavigationController() -> UINavigationController? {
        return navigationController
    }
    
    public override func viewDidLayoutSubviews() {
     /*   let views = ["pageView": pageView!.view]
        heightConstant = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
        view.removeConstraints(constW)
        constW = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(heightConstant)-[pageView]-\(self.tabBarController!.tabBar.frame.height)-|", options: .AlignAllTrailing, metrics: nil, views: views)
        view.addConstraints(constW)
        */
        
    }
    
    
    
    public func filter(filterName : String) -> Void {
        print("FILTERNAME RECEIVED")
        print(filterName)
        
        
        
        let predicate = NSPredicate(format: "talk.trackId = %@", filterName)
        
        let aa = pageView!.viewControllers![0] as! SchedulerTableViewController
        
        var predicateArray = [NSPredicate]()
        predicateArray.append(predicate)
        aa.searchPredicates = predicateArray
        aa.fetchAll()
        
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
