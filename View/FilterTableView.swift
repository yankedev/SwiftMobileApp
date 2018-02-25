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
        self.init(frame: CGRect.zero, style : .plain)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        backgroundColor = ColorManager.filterBackgroundColor
    }
    
    func setupConstraints(referenceView : UIView) {
        
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: referenceView, attribute: NSLayoutAttribute.width, multiplier: 0.5, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: referenceView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: referenceView, attribute: NSLayoutAttribute.top, multiplier: 0.5, constant: 0)
        
        let leftConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: referenceView, attribute: NSLayoutAttribute.right, multiplier: 0.5, constant: 0)
        
        referenceView.addConstraint(widthConstraint)
        referenceView.addConstraint(heightConstraint)
        referenceView.addConstraint(topConstraint)
        referenceView.addConstraint(leftConstraint)
    }
    
}
