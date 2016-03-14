//
//  HomeHeaderView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-21.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class HomeHeaderView : UIView {
    
    let eventLocation = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        
        let title = UIImageView()
        title.image = UIImage(named: "logo.png")
        addSubview(title)
        
        
        eventLocation.textAlignment = .Center
        eventLocation.font = UIFont(name: "Pirulen", size: 25)
        eventLocation.textColor = ColorManager.homeFontColor
        addSubview(eventLocation)
        
        
        
        
        
        //constraints
        
        
        
        let ratio:CGFloat = 600/79
        
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let topLogo = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
        
        let widthLogo = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.6, constant: 0)
        
        let heightLogo = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier:0.6/ratio, constant: 0)
        
        let centerXLogo = NSLayoutConstraint(item: title, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.      CenterX, multiplier: 1, constant: 0)
        
        
        
        self.addConstraint(topLogo)
        
        self.addConstraint(widthLogo)
        
        self.addConstraint(heightLogo)
        
        self.addConstraint(centerXLogo)
        
        
        
        // frame: CGRectMake(40, 75, 300, 40)
        
        
        
        eventLocation.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        let topLocation = NSLayoutConstraint(item: eventLocation, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: title, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let widthLocation = NSLayoutConstraint(item: eventLocation, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.8, constant: 0)
        
        let heightLocation = NSLayoutConstraint(item: eventLocation, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1/ratio, constant: 0)
        
        let centerXLocation = NSLayoutConstraint(item: eventLocation, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        
        
        self.addConstraint(topLocation)
        
        self.addConstraint(widthLocation)
        
        self.addConstraint(heightLocation)
        
        self.addConstraint(centerXLocation)
        
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}