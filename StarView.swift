//
//  StarView.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class StarView : UIView {
    
    let star0 = UIButton()
    let star1 = UIButton()
    let star2 = UIButton()
    let star3 = UIButton()
    let star4 = UIButton()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(star0)
        addSubview(star1)
        addSubview(star2)
        addSubview(star3)
        addSubview(star4)
        
        star0.translatesAutoresizingMaskIntoConstraints = false
        star0.backgroundColor = UIColor.redColor()
        
        star1.translatesAutoresizingMaskIntoConstraints = false
        star1.backgroundColor = UIColor.blueColor()
        
        star2.translatesAutoresizingMaskIntoConstraints = false
        star2.backgroundColor = UIColor.greenColor()
        
        star3.translatesAutoresizingMaskIntoConstraints = false
        star3.backgroundColor = UIColor.grayColor()
        
        star4.translatesAutoresizingMaskIntoConstraints = false
        star4.backgroundColor = UIColor.yellowColor()
        
        
        let views = ["star0": star0, "star1" : star1, "star2" : star2, "star3" : star3, "star4" : star4]
        
        let width = NSLayoutConstraint(item: star0,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.2,
            constant: 0)
        
        addConstraint(width)
        
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[star0]-0-[star1(==star0)]-0-[star2(==star0)]-0-[star3(==star0)]-0-[star4]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        
        let constV0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[star0]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let constV1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[star1]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let constV2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[star2]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let constV3 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[star3]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let constV4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[star4]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)

        addConstraints(constH)
        addConstraints(constV0)
        addConstraints(constV1)
        addConstraints(constV2)
        addConstraints(constV3)
        addConstraints(constV4)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
