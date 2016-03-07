//
//  RateViewController.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class RateViewController : UIViewController, UITextViewDelegate {
    
    
    var talkTitle = UILabel()
    var talkSpeakers = UILabel()
    var stars = StarView(frame: CGRectZero)
    var contentFeedback = RateView()
    var deliveryRemarks = RateView()
    var other = RateView()
    var buttonView = ButtonView()
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        talkTitle.textAlignment = .Center
        talkTitle.numberOfLines = 0
        talkTitle.font = UIFont(name: "Roboto", size: 20)

        talkSpeakers.textAlignment = .Center
        talkSpeakers.font = UIFont(name: "Roboto", size: 15)
        talkSpeakers.numberOfLines = 0

        contentFeedback.label.text = "Content feedback"
        contentFeedback.textView.text = "Type here..."
        contentFeedback.textView.delegate = self

        deliveryRemarks.label.text = "Delivery remarks"
        deliveryRemarks.textView.text = "Type here..."
        deliveryRemarks.textView.delegate = self

        other.label.text = "Other"
        other.textView.text = "Type here..."
        other.textView.delegate = self
        
        talkTitle.translatesAutoresizingMaskIntoConstraints = false
        talkSpeakers.translatesAutoresizingMaskIntoConstraints = false
        stars.translatesAutoresizingMaskIntoConstraints = false
        contentFeedback.translatesAutoresizingMaskIntoConstraints = false
        deliveryRemarks.translatesAutoresizingMaskIntoConstraints = false
        other.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(talkTitle)
        view.addSubview(talkSpeakers)
        view.addSubview(stars)
        view.addSubview(contentFeedback)
        view.addSubview(deliveryRemarks)
        view.addSubview(other)
        view.addSubview(buttonView)
    
        let views = ["talkTitle": talkTitle, "talkSpeakers" : talkSpeakers, "stars" : stars, "contentFeedback": contentFeedback, "deliveryRemarks" : deliveryRemarks, "other" : other, "buttonView" : buttonView]
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTitle]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkSpeakers]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[stars]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[contentFeedback]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[deliveryRemarks]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[other]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[buttonView]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[talkTitle]-0-[talkSpeakers]-0-[stars]-0-[contentFeedback]-0-[deliveryRemarks]-0-[other]-0-[buttonView]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
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
            multiplier: 0.15,
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
        
        
        
    
        
        view.backgroundColor = ColorManager.filterBackgroundColor
        
        let tap = UITapGestureRecognizer(target: self, action: "tap")
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)

    }
    
    public func tap() {
        print("TAP")
        view.endEditing(true)
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Type here..." {
            textView.text = ""
        }
        view.center = CGPointMake(view.center.x, view.center.y - 80)
        textView.becomeFirstResponder()
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type here..."
        }
        view.center = CGPointMake(view.center.x, view.center.y + 80)
        textView.resignFirstResponder()
    }
    
    


}