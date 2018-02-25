//
//  HomeNumberView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-21.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class HomeNumberView : UIView {
    
    var number1 = UILabel()
    var number2 = UILabel()
    var number3 = UILabel()
    
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        number1.font = UIFont(name: "Pirulen", size: 24)!
        number1.textColor = UIColor.white
        number1.textAlignment = .center
        number1.translatesAutoresizingMaskIntoConstraints = false
        
        number2.font = UIFont(name: "Pirulen", size: 24)!
        number2.textColor = UIColor.white
        number2.textAlignment = .center
        number2.translatesAutoresizingMaskIntoConstraints = false
        
        number3.font = UIFont(name: "Pirulen", size: 24)!
        number3.textColor = UIColor.white
        number3.textAlignment = .center
        number3.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(number1)
        addSubview(number2)
        addSubview(number3)
        
        
        label1.text = "DAYS LEFT"
        label1.font = UIFont(name: "Pirulen", size: 8)!
        label1.textColor = UIColor.white
        label1.textAlignment = .center
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        label2.text = "TALKS"
        label2.font = UIFont(name: "Pirulen", size: 8)!
        label2.textColor = UIColor.white
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        label3.text = "CAPACITY"
        label3.font = UIFont(name: "Pirulen", size: 8)!
        label3.textColor = UIColor.white
        label3.textAlignment = .center
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    func createConstraint(_ label : UILabel, centerXFactor : CGFloat, centerYConstant : CGFloat)  {
        
        let number2Height = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.height,
            multiplier: 0,
            constant: 60)
        
        let number2Width = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.width,
            multiplier: 5/19,
            constant: 0)
        
        let number2CenterX = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.centerX,
            multiplier: centerXFactor,
            constant: 0)
        
        let number2CenterY = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: self,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: centerYConstant)
        
        addConstraint(number2Height)
        addConstraint(number2Width)
        
        addConstraint(number2CenterX)
        addConstraint(number2CenterY)
    }
    
    func applyConstraint() {
        
        self.layoutIfNeeded()
        
        
        
        
        
        createConstraint(number1, centerXFactor: 0.4, centerYConstant : 30)
        createConstraint(number2, centerXFactor: 1, centerYConstant : 30)
        createConstraint(number3, centerXFactor: 1.6, centerYConstant : 30)
        
        
        
        createConstraint(label1, centerXFactor: 0.4, centerYConstant : 60)
        createConstraint(label2, centerXFactor: 1, centerYConstant : 60)
        createConstraint(label3, centerXFactor: 1.6, centerYConstant : 60)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
