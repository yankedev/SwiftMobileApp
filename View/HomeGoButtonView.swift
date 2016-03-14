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
        goButton.setTitle("GO !", forState: .Normal)
        goButton.titleLabel?.font = UIFont(name: "Pirulen", size: 25)!
        addSubview(goButton)
        
        
        
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        
    
        let widthLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.9, constant: 0)
        let heightLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier:0.6, constant: 0)
        let centerXLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

        
        let centerYLogo = NSLayoutConstraint(item: goButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        
        
        self.addConstraint(centerYLogo)
        self.addConstraint(widthLogo)
        self.addConstraint(heightLogo)
        self.addConstraint(centerXLogo)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}