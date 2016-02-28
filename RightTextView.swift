//
//  RightTextView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-28.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class RightTextView : UIView {
    
    let topTitleView = TopTitleView()
    var locationView : BottomDetailsView!
    var speakerView : BottomDetailsView!
    var sepView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .ScaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.purpleColor()
        
        addSubview(topTitleView)
        
        
        locationView = BottomDetailsView()
        speakerView = BottomDetailsView()
        
        let imageLocation = UIImage(named: "ic_place")?.imageWithRenderingMode(.AlwaysTemplate)
        let imageMicro = UIImage(named: "ic_microphone")?.imageWithRenderingMode(.AlwaysTemplate)
        
        locationView.image.image = imageLocation
        speakerView.image.image = imageMicro
        
        addSubview(locationView)
        addSubview(speakerView)

        
        sepView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sepView)
        
        
        let views = ["topTitleView": topTitleView, "locationView" : locationView, "speakerView" : speakerView, "sepView" : sepView]
        
        
        
        
        locationView.backgroundColor = UIColor.darkGrayColor()
        
        speakerView.backgroundColor = UIColor.blueColor()
        

        
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[topTitleView]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let constH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[locationView]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[speakerView]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let constH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sepView]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        
        let constV0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[topTitleView]-0-[locationView]-0-[speakerView]-0-[sepView]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        addConstraints(constH0)
        addConstraints(constH1)
        addConstraints(constH2)
        addConstraints(constH3)
        addConstraints(constV0)

        
        
        let topTitleViewHeight = NSLayoutConstraint(item: topTitleView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.6,
            constant: 0)
        
        let locationViewHeight = NSLayoutConstraint(item: locationView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.15,
            constant: 0)
        
        let speakerViewHeight = NSLayoutConstraint(item: speakerView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.15,
            constant: 0)
        
        let sepViewHeight = NSLayoutConstraint(item: sepView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.1,
            constant: 0)
        
        
        addConstraint(topTitleViewHeight)
        addConstraint(locationViewHeight)
        addConstraint(speakerViewHeight)
        addConstraint(sepViewHeight)
        
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

