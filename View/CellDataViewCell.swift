//
//  CellDataViewCell.swift
//  devoxxApp
//
//  Created by maxday on 11.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

class CellDataViewCell: UITableViewCell {
    
    var primaryImage = UIImageView()
    
    var firstInformation = UILabel()
    var secondInformation = UILabel()
    var thirdInformation = UILabel()
    
    func configureCell() {
        
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        let rightView = UIView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        primaryImage.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(primaryImage)
        
        firstInformation.translatesAutoresizingMaskIntoConstraints = false
        firstInformation.font = UIFont(name: "Roboto", size: 14)
        rightView.addSubview(firstInformation)
        
        secondInformation = UILabel()
        secondInformation.translatesAutoresizingMaskIntoConstraints = false
        secondInformation.font = UIFont(name: "Roboto", size: 8)
        rightView.addSubview(secondInformation)
        
        thirdInformation.translatesAutoresizingMaskIntoConstraints = false
        thirdInformation.font = UIFont(name: "Roboto", size: 6)
        thirdInformation.textAlignment = .center
        thirdInformation.layer.masksToBounds = true;
        thirdInformation.layer.cornerRadius = 3.0;
        leftView.addSubview(thirdInformation)
        
        addSubview(rightView)
        addSubview(leftView)
        
        
        let viewsDictionary = ["info":leftView, "talk":rightView]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[info(40)]-5-[talk]-5-|", options: layout, metrics: nil, views: viewsDictionary)
        
        
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
        
        let topTalkRoomConstraint = NSLayoutConstraint(item: secondInformation, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: secondInformation.superview, attribute: NSLayoutAttribute.bottom, multiplier: 0.7, constant: 0)
        
        let heightTalkRoomConstraint = NSLayoutConstraint(item: secondInformation, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: rightView, attribute: NSLayoutAttribute.height, multiplier: 0.3, constant: 0)
        
        let widthTalkRoomConstraint = NSLayoutConstraint(item: secondInformation, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: secondInformation.superview, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        
        let leadingTalkRoomConstraint = NSLayoutConstraint(item: secondInformation, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: rightView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        
        rightView.addConstraint(widthTalkRoomConstraint)
        rightView.addConstraint(heightTalkRoomConstraint)
        rightView.addConstraint(topTalkRoomConstraint)
        rightView.addConstraint(leadingTalkRoomConstraint)
        
        let topPrimaryImageConstraint = NSLayoutConstraint(item: primaryImage, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: primaryImage.superview, attribute: NSLayoutAttribute.bottom, multiplier: 0.1, constant: 0)
        
        let heightPrimaryImageConstraint = NSLayoutConstraint(item: primaryImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: primaryImage.superview, attribute: NSLayoutAttribute.width, multiplier: 0.6, constant: 0)
        
        let widthPrimaryImageConstraint = NSLayoutConstraint(item: primaryImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: primaryImage.superview, attribute: NSLayoutAttribute.width, multiplier: 0.6, constant: 0)
        
        let centerXPrimaryImageConstraint = NSLayoutConstraint(item: primaryImage, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: primaryImage.superview, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        leftView.addConstraint(topPrimaryImageConstraint)
        leftView.addConstraint(heightPrimaryImageConstraint)
        leftView.addConstraint(widthPrimaryImageConstraint)
        leftView.addConstraint(centerXPrimaryImageConstraint)
        
        let topThirdInformationConstraint = NSLayoutConstraint(item: thirdInformation, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: thirdInformation.superview, attribute: NSLayoutAttribute.bottom, multiplier: 0.7, constant: 0)
        
        let heightThirdInformationConstraint = NSLayoutConstraint(item: thirdInformation, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: thirdInformation.superview, attribute: NSLayoutAttribute.width, multiplier: 0.2, constant: 0)
        
        let widthThirdInformationConstraint = NSLayoutConstraint(item: thirdInformation, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: thirdInformation.superview, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        
        let leadingThirdInformationConstraint = NSLayoutConstraint(item: thirdInformation, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: thirdInformation.superview, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        
        leftView.addConstraint(topThirdInformationConstraint)
        leftView.addConstraint(heightThirdInformationConstraint)
        leftView.addConstraint(widthThirdInformationConstraint)
        leftView.addConstraint(leadingThirdInformationConstraint)
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
