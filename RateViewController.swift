//
//  RateViewController.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class RateViewController : UIViewController {
    
    
    var talkTitle = UILabel()
    var talkSpeakers = UILabel()
    var stars = UIView()
    var contentFeedback = UILabel()
    var deliveryRemarks = UILabel()
    var other = UILabel()
    var voteBtn = UIButton()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        talkTitle.backgroundColor = UIColor.redColor()
        talkSpeakers.backgroundColor = UIColor.blueColor()
        stars.backgroundColor = UIColor.purpleColor()
        contentFeedback.backgroundColor = UIColor.lightGrayColor()
        deliveryRemarks.backgroundColor = UIColor.darkGrayColor()
        other.backgroundColor = UIColor.redColor()
        voteBtn.backgroundColor = UIColor.greenColor()
        
        talkTitle.translatesAutoresizingMaskIntoConstraints = false
        talkSpeakers.translatesAutoresizingMaskIntoConstraints = false
        stars.translatesAutoresizingMaskIntoConstraints = false
        contentFeedback.translatesAutoresizingMaskIntoConstraints = false
        deliveryRemarks.translatesAutoresizingMaskIntoConstraints = false
        other.translatesAutoresizingMaskIntoConstraints = false
        voteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(talkTitle)
        view.addSubview(talkSpeakers)
        view.addSubview(stars)
        view.addSubview(contentFeedback)
        view.addSubview(deliveryRemarks)
        view.addSubview(other)
        view.addSubview(voteBtn)
    
        let views = ["talkTitle": talkTitle, "talkSpeakers" : talkSpeakers, "stars" : stars, "contentFeedback": contentFeedback, "deliveryRemarks" : deliveryRemarks, "other" : other, "voteBtn" : voteBtn]
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[talkTitle]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[talkSpeakers]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[stars]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentFeedback]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[deliveryRemarks]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[other]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[voteBtn]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[talkTitle]-0-[talkSpeakers]-0-[stars]-0-[contentFeedback]-0-[deliveryRemarks]-0-[other]-0-[voteBtn]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        view.addConstraints(constH0)
        view.addConstraints(constH1)
        view.addConstraints(constH2)
        view.addConstraints(constH3)
        view.addConstraints(constH4)
        view.addConstraints(constH5)
        view.addConstraints(constH6)
        view.addConstraints(constV)
        
        
        let height0 = NSLayoutConstraint(item: talkTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.15,
            constant: 0)
        
        let height1 = NSLayoutConstraint(item: talkSpeakers,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.10,
            constant: 0)
        
        let height2 = NSLayoutConstraint(item: stars,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.20,
            constant: 0)
        
        let height3 = NSLayoutConstraint(item: contentFeedback,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.15,
            constant: 0)
        
        let height4 = NSLayoutConstraint(item: deliveryRemarks,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.15,
            constant: 0)
        
        let height5 = NSLayoutConstraint(item: other,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.15,
            constant: 0)
       /*
        let height0 = NSLayoutConstraint(item: voteBtn,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.10,
            constant: 0)
        */
        
        
        
        view.addConstraint(height0)
        view.addConstraint(height1)
        view.addConstraint(height2)
        view.addConstraint(height3)
        view.addConstraint(height4)
        view.addConstraint(height5)
        

    }


}