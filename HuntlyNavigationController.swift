//
//  HuntlyNavigationController.swift
//  My_Devoxx
//
//  Created by Maxime on 06/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class HuntlyNavigationController : UINavigationController {

    var huntlyLeftButton:UIBarButtonItem?

    override public func viewDidLoad() {
        print("HuntlyNavigationController")
        let huntlyPointView = UIImageView(frame : CGRectMake(0, 0, 30, 30))
        huntlyPointView.image = UIImage(named: "DevoxxHuntlyIntegrationIcon")
        
        let huntlyPointLbl = UILabel(frame : CGRectMake(0, 0, 30, 30))
        
        huntlyPointLbl.text = HuntlyManager.getHuntlyPoints()
        huntlyPointLbl.font = UIFont(name: "Roboto", size: 12)
        huntlyPointView.addSubview(huntlyPointLbl)
        huntlyPointLbl.textAlignment = .Center
        
        huntlyLeftButton = UIBarButtonItem(customView: huntlyPointView)
        
    }

}