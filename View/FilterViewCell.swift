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


class FilterViewCell: UITableViewCell {
    
    var attributeImage = UIImageView()
    var attributeTitle = UILabel()
    var tickedImg = UIImageView()
    
    
    func configureCell() {
        
        attributeImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(attributeImage)
        
        attributeTitle.translatesAutoresizingMaskIntoConstraints = false
        attributeTitle.font = UIFont(name: "Roboto", size: 12)
        self.addSubview(attributeTitle)
        
        tickedImg.translatesAutoresizingMaskIntoConstraints = false
        tickedImg.image = UIImage(named: "checkboxOn")
        self.addSubview(tickedImg)
        
        setupConstraints()
        
    }
    
    func updateBackgroundColor(_ isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.white
        }
    }
    
    fileprivate func setupConstraints() {
        let viewsDictionary = ["attributeImage":attributeImage,"attributeTitle":attributeTitle, "tickedImg":tickedImg] as [String : Any]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[attributeImage(20)]-5-[attributeTitle]-5-[tickedImg(16)]-7-|", options: layout, metrics: nil, views: viewsDictionary)
        let verticalContraint_1:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[attributeImage]-12-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let verticalContraint_2:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[attributeTitle]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let verticalContraint_3:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[tickedImg]-14-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(verticalContraint_1)
        self.addConstraints(verticalContraint_2)
        self.addConstraints(verticalContraint_3)
        self.addConstraints(horizontalContraint)
        
    }
    
}

