//
//  BottomDetailsView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-28.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class BottomDetailsView : UIView {
    
    
    var image:UIImageView!
    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
     

        translatesAutoresizingMaskIntoConstraints = false
        
        //backgroundColor = UIColor.greenColor()
        
        
        
        
        
        
        label = UILabel()
        label.font = UIFont(name: "Roboto", size: 12)
        label.textColor = ColorManager.grayImageColor
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = UIColor.redColor()
        
        
        image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.backgroundColor = UIColor.yellowColor()
        image.tintColor = ColorManager.grayImageColor
        
        
        addSubview(image)
        addSubview(label)
        
        
        let views = ["image": image, "label" : label]
        
       

        
        //let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[image]-0-[label]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        //addConstraints(constH0)
   
         let imageHeight = NSLayoutConstraint(item: image,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1,
            constant: 0)
        
        let imageTop = NSLayoutConstraint(item: image,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        
        let imageLeft = NSLayoutConstraint(item: image,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1,
            constant: 0)
        
        
        let labelLeft = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: image,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 0)
        
        let labelTop = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0)
        
        
        let labelHeight = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1,
            constant: 0)
        
        let imageWidth = NSLayoutConstraint(item: image,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1,
            constant: 0)
        
        
        addConstraint(imageTop)
        addConstraint(imageHeight)
        addConstraint(imageWidth)
        addConstraint(labelHeight)
        addConstraint(labelTop)
        
        addConstraint(imageLeft)
        addConstraint(labelLeft)
        
        
        
        label.text = "SUPER"
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
