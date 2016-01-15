//
//  FilterTableView.swift
//  devoxxApp
//
//  Created by maxday on 15.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class FilterTableView : UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style:style)
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero, style : .Plain)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .None
        backgroundColor = ColorManager.filterBackgroundColor
    }
    
    func setupConstraints(referenceView referenceView : UIView) {
        
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: NSLayoutAttribute.Top, multiplier: 0.5, constant: 0)
        
        let leftConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: referenceView, attribute: NSLayoutAttribute.Right, multiplier: 0.5, constant: 0)
        
        referenceView.addConstraint(widthConstraint)
        referenceView.addConstraint(heightConstraint)
        referenceView.addConstraint(topConstraint)
        referenceView.addConstraint(leftConstraint)
    }
    
}