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
    
    var filterRightButton:UIBarButtonItem

    init(target: AnyObject?, filterSelector:Selector) {
        
        let img = UIImage(named: "ic_filter_inactive")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        filterRightButton = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: target, action: filterSelector)
        
        super.init(frame: CGRect.zero)
        self.initialize()
    }
    
    
    override init(frame: CGRect) {
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
