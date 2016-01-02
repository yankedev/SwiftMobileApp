//
//  DemoController.swift
//  devoxxApp
//
//  Created by maxday on 02.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit


public class DemoController: UIViewController {


    var index:NSInteger = 0
    
    public override func viewDidLoad() {
        var color = UIColor.blackColor()
        
        switch(index) {
        case 0 : color = UIColor.blueColor()
            break
        case 1 : color = UIColor.redColor()
            break
        case 2 : color = UIColor.yellowColor()
            break
        case 3 : color = UIColor.greenColor()
            break
        case 4 : color = UIColor.purpleColor()
            break
        default:
            print("default")
            break
        }
        
        self.view.backgroundColor = color
        
    }

}