//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleController : UINavigationController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, DevoxxAppFilter {

    var favoriteSwitcher : UISegmentedControl!
    var pageViewController : UIPageViewController?
    
    var overlay:FilterTableViewController?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteSwitcher = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
        favoriteSwitcher.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        favoriteSwitcher.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        favoriteSwitcher.selectedSegmentIndex = 0
        favoriteSwitcher.tintColor = UIColor.whiteColor()
        favoriteSwitcher.addTarget(self, action: Selector("changeSchedule:"), forControlEvents: .ValueChanged)
        
        let filterRightButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: Selector("filterMe"))
        
        
        self.navigationBar.translucent = false
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        
        let demo = viewControllerAtIndex(0)
        let controls = [demo]
        
        pageViewController?.setViewControllers(controls, direction: .Forward, animated: false, completion: nil)
        
        pushViewController(pageViewController!, animated: false)
        
        self.view.backgroundColor = ColorManager.bottomDotsPageController
        self.topViewController?.navigationItem.titleView = favoriteSwitcher
        self.topViewController?.navigationItem.rightBarButtonItem = filterRightButton

    }
    
    
    
    func filter(filters : [String: [Attribute]]) -> Void {
        
        
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
                
                
                //
                
                if pageViewController != nil && pageViewController!.viewControllers != nil{
                    if let filterableTable = pageViewController!.viewControllers![0] as? FilterableTableProtocol {
                        if filterableTable.getCurrentFilters() != nil {
                            overlay?.selected = filterableTable.getCurrentFilters()!
                        }
                    }
                }
                
                
                //
                
                pageViewController!.viewControllers![0].view.addSubview((overlay?.tableView)!)
                overlay?.tableView.translatesAutoresizingMaskIntoConstraints = false
            
                overlay?.devoxxAppFilterDelegate = self
            
            
                let widthConstraint = NSLayoutConstraint(item: overlay!.tableView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: overlay?.tableView.superview, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
            
                let heightConstraint = NSLayoutConstraint(item: overlay!.tableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: overlay?.tableView.superview, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
            
                let topConstraint = NSLayoutConstraint(item: overlay!.tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: overlay?.tableView.superview, attribute: NSLayoutAttribute.Top, multiplier: 0.5, constant: 0)
            
                let leftConstraint = NSLayoutConstraint(item: overlay!.tableView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: overlay?.tableView.superview, attribute: NSLayoutAttribute.Right, multiplier: 0.5, constant: 0)
            
                overlay?.tableView.superview!.addConstraint(widthConstraint)
                overlay?.tableView.superview!.addConstraint(heightConstraint)
                overlay?.tableView.superview!.addConstraint(topConstraint)
                overlay?.tableView.superview!.addConstraint(leftConstraint)

            }
            else {
                removeOverlay()
            }
        
        }
    }
    
    func removeOverlay() {
        overlay?.tableView.removeFromSuperview()
        overlay = nil
    }
    
    func changeSchedule(sender : UISegmentedControl) {
        if pageViewController != nil && pageViewController!.viewControllers != nil{
            if let switchable = pageViewController!.viewControllers![0] as? SwitchableProtocol {
                switchable.updateSwitch(sender.selectedSegmentIndex == 1)
                switchable.performSwitch()
            }
        }
    }

    
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var currentIndex = 0
        if let demoController = viewController as? SchedulerTableViewController {
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
        if let demoController = viewController as? SchedulerTableViewController {
            currentIndex = demoController.index
        }
        
        currentIndex++
        
        
        if currentIndex == 3 {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    public func viewControllerAtIndex(index : NSInteger) -> SchedulerTableViewController {
        
        let demoController = SchedulerTableViewController()
        demoController.index = index
        
        return demoController
    }
    
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            removeOverlay()
            if pageViewController.viewControllers != nil {
                if let fav = pageViewController.viewControllers![0] as? SwitchableProtocol {
                    //not optimal
                    fav.updateSwitch(favoriteSwitcher.selectedSegmentIndex == 1)
                    fav.performSwitch()
                }
            }
        }
        
    }
    
}
