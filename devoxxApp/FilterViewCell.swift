//
//  FilterViewCell.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-31.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


class FilterViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var attributeImage:UIImageView!
    var attributeTitle:UILabel!
    var tickedImg:UIImageView!
    
    var delegate: ScheduleViewCellDelegate!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
        attributeImage = UIImageView()
        attributeImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(attributeImage)
        
        attributeTitle = UILabel()
        attributeTitle.translatesAutoresizingMaskIntoConstraints = false
        attributeTitle.font = UIFont(name: "Roboto", size: 12)
        self.addSubview(attributeTitle)
        
        tickedImg = UIImageView()
        tickedImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tickedImg)
        
        tickedImg.image = UIImage(named: "checkboxOff")
        
        let viewsDictionary = ["attributeImage":attributeImage,"attributeTitle":attributeTitle, "tickedImg":tickedImg]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[attributeImage(20)]-5-[attributeTitle]-5-[tickedImg(16)]-7-|", options: layout, metrics: nil, views: viewsDictionary)
        
        let verticalContraint_1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[attributeImage]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let verticalContraint_2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[attributeTitle]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let verticalContraint_3:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[tickedImg]-14-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(verticalContraint_1)
        self.addConstraints(verticalContraint_2)
        self.addConstraints(verticalContraint_3)
        self.addConstraints(horizontalContraint)
        
    }
    
    func updateBackgroundColor(isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    
}

