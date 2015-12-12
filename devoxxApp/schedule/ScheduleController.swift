//
//  ScheduleController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class ScheduleController : UIViewController {

    var seg : UISegmentedControl!
    var childTableController:SchedulerTableViewController!
    
    override public func viewDidLoad() {
        
        
        
        childTableController = SchedulerTableViewController()
        self.addChildViewController(childTableController)
        self.view.addSubview(childTableController.tableView)

        
        seg = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
        seg.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        seg.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        seg.selectedSegmentIndex = 0
        seg.tintColor = UIColor.whiteColor()
        seg.addTarget(childTableController, action: Selector("changeSchedule:"), forControlEvents: .ValueChanged)
        self.navigationItem.titleView = seg
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = searchButton
    
    }
    
   
    
    

    
}

