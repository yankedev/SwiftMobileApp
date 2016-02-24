//
//  InfoDetailView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-25.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit

class InfoDetailView : UIView {
    
    let firstInfo = UILabel()
    let secondInfo = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        firstInfo.font = UIFont(name: "Roboto", size: 12)
        firstInfo.textColor = UIColor.lightGrayColor()
        secondInfo.font = UIFont(name: "Roboto", size: 13)
        secondInfo.textColor = UIColor.darkGrayColor()


        
        firstInfo.translatesAutoresizingMaskIntoConstraints = false
        //firstInfo.backgroundColor = UIColor.yellowColor()
        
        secondInfo.translatesAutoresizingMaskIntoConstraints = false
        //secondInfo.backgroundColor = UIColor.grayColor()
        secondInfo.textContainer.lineFragmentPadding = 0;
        secondInfo.editable = false
        secondInfo.textContainerInset = UIEdgeInsetsZero
        
        
        
        addSubview(firstInfo)
        addSubview(secondInfo)
        
        
        
        let innerViews = ["firstInfo": firstInfo, "secondInfo" : secondInfo]
        
        
        let constH11 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[firstInfo]-0-|", options: .AlignAllBaseline, metrics: nil, views: innerViews)
        let constH12 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[secondInfo]-0-|", options: .AlignAllBaseline, metrics: nil, views: innerViews)
        let constV11 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[firstInfo]-0-[secondInfo]-0-|", options: .AlignAllCenterX, metrics: nil, views: innerViews)
        
        
        
        
        addConstraints(constH11)
        addConstraints(constH12)
        addConstraints(constV11)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
    
    }
}



