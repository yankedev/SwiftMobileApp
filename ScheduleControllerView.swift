//
//  ScheduleControllerView.swift
//  devoxxApp
//
//  Created by maxday on 22.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class ScheduleControllerView : UIView {
    
    var favoriteSwitcher = UISegmentedControl(frame: CGRectMake(0, 0, 200, 30))

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        favoriteSwitcher.insertSegmentWithTitle("Schedule", atIndex: 0, animated: true)
        favoriteSwitcher.insertSegmentWithTitle("My schedule", atIndex: 1, animated: true)
        favoriteSwitcher.selectedSegmentIndex = 0
        favoriteSwitcher.tintColor = UIColor.whiteColor()
    }
    
    
    
}