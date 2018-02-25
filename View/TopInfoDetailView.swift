//
//  TopInfoDetailView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-24.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class TopInfoDetailView : UIView {
    
    let firstInfo = UILabel()
    let secondInfo = UITextView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        firstInfo.font = UIFont(name: "Roboto", size: 14)
        firstInfo.textColor = UIColor.lightGray
        secondInfo.font = UIFont(name: "Roboto", size: 15)
        secondInfo.textColor = UIColor.darkGray
        
        
        
        
        firstInfo.translatesAutoresizingMaskIntoConstraints = false
        //firstInfo.backgroundColor = UIColor.yellowColor()
        
        secondInfo.translatesAutoresizingMaskIntoConstraints = false
        //secondInfo.backgroundColor = UIColor.grayColor()
        secondInfo.textContainer.lineFragmentPadding = 0;
        secondInfo.isEditable = false
        secondInfo.textContainerInset = UIEdgeInsets.zero
        
        
        
        addSubview(firstInfo)
        addSubview(secondInfo)
        
        
        let firstViewHeight = NSLayoutConstraint(item: firstInfo,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 0.5,
            constant: 0)
        
        let secondViewHeight = NSLayoutConstraint(item: secondInfo,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 0.5,
            constant: 0)
        
        self.addConstraint(firstViewHeight)
        self.addConstraint(secondViewHeight)
        
        let innerViews = ["firstInfo": firstInfo, "secondInfo" : secondInfo] as [String : Any]
        
        
        let constH11 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[firstInfo]-0-|", options: .alignAllLastBaseline, metrics: nil, views: innerViews)
        let constH12 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[secondInfo]-0-|", options: .alignAllLastBaseline, metrics: nil, views: innerViews)
        let constV11 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[firstInfo]-0-[secondInfo]-0-|", options: .alignAllCenterX, metrics: nil, views: innerViews)
        
        
        
        
        addConstraints(constH11)
        addConstraints(constH12)
        addConstraints(constV11)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}






