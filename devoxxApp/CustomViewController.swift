//
//  CustomViewController.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-13.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import UIKit

public class CustomViewController : UIViewController {
    
    var childTableController = SchedulerTableViewController()

    var index:NSInteger = 0
    
   

    public override func viewDidLoad() {

        childTableController.index = index
        self.addChildViewController(childTableController)
        self.view.addSubview(childTableController.tableView)



              
        switch index%3 {
        case 0 :
            self.view.backgroundColor = UIColor.redColor()
            break
        case 1 :
            self.view.backgroundColor = UIColor.whiteColor()
            break
        default :
             self.view.backgroundColor = UIColor.blueColor()
            break
        }

    }
}