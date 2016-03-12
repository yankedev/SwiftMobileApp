//
//  GenericPageScrollController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-18.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit


public protocol ScrollableItemProtocol : NSObjectProtocol {
    var index:Int { get set }
}

public class GenericPageScrollController<T : ScrollableItemProtocol> : UINavigationController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var generator: () -> ScrollableItemProtocol
    var pageViewController : UIPageViewController!
    

    
    var customView:ScheduleControllerView?
    
    init(generator: () -> ScrollableItemProtocol) {
        self.generator = generator
        super.init(navigationBarClass: nil, toolbarClass: nil)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        customView = ScheduleControllerView(target: self, filterSelector: Selector("filterMe"))
        
        
        
        
        
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
        
        
        
        
        
     
        
        self.view.addSubview(customView!)
        
        
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
        
        
        if currentIndex == 3 {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)
    }
    
    
    public func viewControllerAtIndex(index : NSInteger) -> UIViewController {
        
        let scheduleTableController:T = generator() as! T
        scheduleTableController.index = index
        
        
        return (scheduleTableController as? UIViewController)!
    }
    
    
    public func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    public func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
                //print("completed")
        }
        
    }
    
    
  
    
}
