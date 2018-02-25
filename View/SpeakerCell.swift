//
//  SpeakerCell.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-17.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

class SpeakerCell: UITableViewCell {
    
    var initiale = UILabel()
    var firstInformation = UILabel()
    
    
    
    func configureCell() {
        
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        let rightView = UIView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        initiale.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(initiale)
        
        firstInformation.translatesAutoresizingMaskIntoConstraints = false
        firstInformation.font = UIFont(name: "Roboto", size: 14)
        rightView.addSubview(firstInformation)
        
        
        addSubview(rightView)
        addSubview(leftView)
        
        
        let viewsDictionary = ["info":leftView, "talk":rightView]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[info(60)]-5-[talk]-5-|", options: layout, metrics: nil, views: viewsDictionary)
        
        
        let verticalContraint_1:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[info]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let verticalContraint_2:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[talk]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(verticalContraint_1)
        self.addConstraints(verticalContraint_2)
        self.addConstraints(horizontalContraint)
        
        
        let widthFirstInformationConstraint = NSLayoutConstraint(item: firstInformation, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: rightView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
        
        let heightFirstInformationConstraint = NSLayoutConstraint(item: firstInformation, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: rightView, attribute: NSLayoutAttribute.height, multiplier: 0.7, constant: 0)
        
        let topFirstInformationConstraint = NSLayoutConstraint(item: firstInformation, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: rightView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        
        let leadingFirstInformationConstraint = NSLayoutConstraint(item: firstInformation, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: rightView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        
        
        rightView.addConstraint(widthFirstInformationConstraint)
        rightView.addConstraint(heightFirstInformationConstraint)
        rightView.addConstraint(topFirstInformationConstraint)
        rightView.addConstraint(leadingFirstInformationConstraint)
        
        
        
        let topPrimaryImageConstraint = NSLayoutConstraint(item: initiale, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: initiale.superview, attribute: NSLayoutAttribute.bottom, multiplier: 0.1, constant: 0)
        
        let heightPrimaryImageConstraint = NSLayoutConstraint(item: initiale, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: initiale.superview, attribute: NSLayoutAttribute.width, multiplier: 0.6, constant: 0)
        
        let widthPrimaryImageConstraint = NSLayoutConstraint(item: initiale, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: initiale.superview, attribute: NSLayoutAttribute.width, multiplier: 0.6, constant: 0)
        
        let centerXPrimaryImageConstraint = NSLayoutConstraint(item: initiale, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: initiale.superview, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        leftView.addConstraint(topPrimaryImageConstraint)
        leftView.addConstraint(heightPrimaryImageConstraint)
        leftView.addConstraint(widthPrimaryImageConstraint)
        leftView.addConstraint(centerXPrimaryImageConstraint)
        
    }
    
    func updateBackgroundColor(_ isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.white
        }
    }
    
    
}
