//
//  HuntlyNavigationController.swift
//  My_Devoxx
//
//  Created by Maxime on 06/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

open class HuntlyNavigationController : UINavigationController {

    var huntlyLeftButton:UIBarButtonItem?
    //var huntlyPointLbl:UILabel!

    override open func viewDidLoad() {
        
        let huntlyPointView = UIImageView(frame : CGRect(x: 0, y: 0, width: 30, height: 30))
        huntlyPointView.image = UIImage(named: "DevoxxHuntlyIntegrationIcon")
      
        
        /*
        huntlyPointLbl = UILabel(frame : CGRectMake(0, 0, 30, 30))
        
        huntlyPointLbl.text = HuntlyManagerService.sharedInstance.getHuntlyPoints()
        huntlyPointLbl.font = UIFont(name: "Roboto", size: 12)
        huntlyPointView.addSubview(huntlyPointLbl)
        huntlyPointLbl.textAlignment = .Center
        */
        huntlyLeftButton = UIBarButtonItem(customView: huntlyPointView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickScore))
        huntlyPointView.addGestureRecognizer(tapGesture)
        
 
    }

    open override func viewWillAppear(_ animated: Bool) {
        HuntlyManagerService.sharedInstance.feedEventId(updateScore, callbackFailure: updateScore)
    }
    
    func updateScore() {
        HuntlyManagerService.sharedInstance.updateScore(refreshScore)
    }
    
    func refreshScore() {
        //huntlyPointLbl.text = HuntlyManagerService.sharedInstance.getHuntlyPoints()
    }
    
    func clickScore() {
        //HuntlyManagerService.sharedInstance.goDeepLink()
    }
}
