//
//  BottomInfoDetailView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-24.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class BottomInfoDetailView : InfoDetailView {

    override func configure() {
        
        
        let firstViewHeight = NSLayoutConstraint(item: super.firstInfo,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.2,
            constant: 0)
        
        let secondViewHeight = NSLayoutConstraint(item: super.secondInfo,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.8,
            constant: 0)
        
        self.addConstraint(firstViewHeight)
        self.addConstraint(secondViewHeight)
        
        
        
    }
  
}






