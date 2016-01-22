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
    
    var favoriteSwitcher = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))
    var filterRightButton:UIBarButtonItem
    
    
    
    
    init(target: AnyObject?, filterSelector:Selector) {
        self.filterRightButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: target, action: filterSelector)
        super.init(frame: CGRectZero)
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
        favoriteSwitcher.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        favoriteSwitcher.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        favoriteSwitcher.selectedSegmentIndex = 0
        favoriteSwitcher.tintColor = UIColor.whiteColor()
        
        backgroundColor = ColorManager.bottomDotsPageController
    }
    
    
    
}