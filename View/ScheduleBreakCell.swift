//
//  ScheduleBreakCell.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-28.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

class ScheduleBreakCell : UITableViewCell {
    
    var leftIconView = LeftIconView(frame: CGRect.zero)
    var rightTextView = UILabel(frame: CGRect.zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(leftIconView)
        addSubview(rightTextView)
        
        
        
        
        
        rightTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["leftIconView": leftIconView, "rightTextView" : rightTextView] as [String : Any]
        
        
        let constH0 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[leftIconView(50)]-0-[rightTextView]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        
        
        addConstraints(constH0)
        
        
        leftIconView.setup()
        
        
        let leftIconViewHeight = NSLayoutConstraint(item: leftIconView,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 1,
            constant: 0)
        
        let rightTextViewHeight = NSLayoutConstraint(item: rightTextView,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 1,
            constant: 0)
        
        addConstraint(leftIconViewHeight)
        addConstraint(rightTextViewHeight)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
        
        
        
    }
    
    
    
    
}

