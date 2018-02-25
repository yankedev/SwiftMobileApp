//
//  HomeGoButtonView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-21.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class HomeGoButtonView : UIView {
    
    let goButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        goButton.backgroundColor = ColorManager.homeFontColor
        goButton.setTitle("GO !", for: UIControlState())
        goButton.titleLabel?.font = UIFont(name: "Pirulen", size: 25)!
        addSubview(goButton)
        
        
        
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let widthLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 0.9, constant: 0)
        let heightLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier:0.6, constant: 0)
        let centerXLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        
        let centerYLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        
        
        self.addConstraint(centerYLogo)
        self.addConstraint(widthLogo)
        self.addConstraint(heightLogo)
        self.addConstraint(centerXLogo)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
