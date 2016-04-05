//
//  ScheduleControllerView.swift
//  devoxxApp
//
//  Created by maxday on 22.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit


protocol TopFilterableProtocol {
    var filterRightButton:UIBarButtonItem { get set }
}

class ScheduleControllerView : UIView, TopFilterableProtocol {
    

    var huntlyLeftButton:UIBarButtonItem
    var filterRightButton:UIBarButtonItem

    let huntlyPointLbl = UILabel(frame : CGRectMake(0, 0, 30, 30))
    
    init(target: AnyObject?, filterSelector:Selector) {
        
        
        let img = UIImage(named: "ic_filter_inactive")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        filterRightButton = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: target, action: filterSelector)
        
        let huntlyPointView = UIImageView(frame : CGRectMake(0, 0, 30, 30))
        huntlyPointView.image = UIImage(named: "DevoxxHuntlyIntegrationIcon")
        
        
        huntlyPointLbl.text = HuntlyManager.getHuntlyPoints()
        huntlyPointLbl.font = UIFont(name: "Roboto", size: 12)
        huntlyPointView.addSubview(huntlyPointLbl)
        huntlyPointLbl.textAlignment = .Center
     
        
        
        
        
        huntlyLeftButton = UIBarButtonItem(customView: huntlyPointView)
        
        
        
        
        super.init(frame: CGRectZero)
        self.initialize()
    }
    
    
    override init(frame: CGRect) {
        self.huntlyLeftButton = UIBarButtonItem()
        self.filterRightButton = UIBarButtonItem()
        super.init(frame: frame)
        self.initialize()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        backgroundColor = ColorManager.bottomDotsPageController
    }
    
    
    
}