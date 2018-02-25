//
//  GobalDetailView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-26.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class GobalDetailView : UIView {
    
    
    let left = AllDetailsView()
    let right = SpeakerListView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(left)
        addSubview(right)
        
        let views = ["left": left, "right" : right] as [String : Any]
        
        
        let heightLeft = NSLayoutConstraint(item: left,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 1,
            constant: 0)
        
        addConstraint(heightLeft)
        
        
        let heightRight = NSLayoutConstraint(item: right,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 1,
            constant: 0)
        
        addConstraint(heightRight)
        
        
        let widthLeft = NSLayoutConstraint(item: left,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.width,
            multiplier: 0.50,
            constant: 0)
        
        addConstraint(widthLeft)
        
        
        /*let widthRight = NSLayoutConstraint(item: right,
        attribute: NSLayoutAttribute.Width,
        relatedBy: NSLayoutRelation.Equal,
        toItem: self,
        attribute: NSLayoutAttribute.Width,
        multiplier: 0.50,
        constant: 0)
        
        addConstraint(widthRight)
        */
        
        
        let constH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[left]-0-[right]-10-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let constV0 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[left]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        let constV1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[right]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        
        addConstraints(constH)
        addConstraints(constV0)
        addConstraints(constV1)
        
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
