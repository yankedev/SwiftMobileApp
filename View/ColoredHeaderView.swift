//
//  ColoredHeaderView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class ColoredHeaderView : UIImageView {
    
    var talkTitle : UILabel!
    var talkTrack : UILabel!
    var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .ScaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        
        talkTitle = UILabel()
        talkTitle.textAlignment = .Justified
        talkTitle.textColor = UIColor.whiteColor()
        //talkTitle.backgroundColor = UIColor.redColor()
        talkTitle.font = UIFont(name: "Roboto", size: 20)
        talkTitle.translatesAutoresizingMaskIntoConstraints = false
        talkTitle.numberOfLines = 2
        
        
        talkTrack = UILabel()
        talkTrack.textAlignment = .Justified
        talkTrack.textColor = UIColor.whiteColor()
        //talkTrack.backgroundColor = UIColor.greenColor()
        talkTrack.font = UIFont(name: "Roboto", size: 17)
        talkTrack.translatesAutoresizingMaskIntoConstraints = false
        talkTrack.numberOfLines = 0
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(talkTitle)
        addSubview(talkTrack)
        addSubview(imageView)
        
        
        
        
        let talkTitleHeight = NSLayoutConstraint(item: talkTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.5,
            constant: 0)
        
        let talkTitleTop = NSLayoutConstraint(item: talkTitle,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 0.3,
            constant: 0)
        
        addConstraint(talkTitleHeight)
        addConstraint(talkTitleTop)
        
        let talkTrackHeight = NSLayoutConstraint(item: talkTrack,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.2,
            constant: 0)
        
        let talkTrackTop = NSLayoutConstraint(item: talkTrack,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 0.8,
            constant: 0)
        
        
        addConstraint(talkTrackHeight)
        addConstraint(talkTrackTop)
        
        
        
        
        
        
        
        let views = ["talkTitle" : talkTitle, "talkTrack" : talkTrack]
        
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTitle]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTrack]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        
        
        addConstraints(constH0)
        addConstraints(constH1)
        
        
        
        
        let imgViewHeight = NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 70)
        
        let imgViewWidth = NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 70)
        
        let imgViewTop = NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 20)
        
        let imgViewRight = NSLayoutConstraint(item: imageView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: -20)
        
        imageView.layer.cornerRadius = 70 / 2
        imageView.layer.masksToBounds = true
        
        addConstraint(imgViewHeight)
        addConstraint(imgViewWidth)
        addConstraint(imgViewTop)
        addConstraint(imgViewRight)
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}






