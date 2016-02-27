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
        

        number1.text = "102"
        number1.font = UIFont(name: "Pirulen", size: 30)!
        number1.textColor = UIColor.whiteColor()
        number1.textAlignment = .Center
        number1.translatesAutoresizingMaskIntoConstraints = false

        number2.text = "230"
        number2.font = UIFont(name: "Pirulen", size: 30)!
        number2.textColor = UIColor.whiteColor()
        number2.textAlignment = .Center
        number2.translatesAutoresizingMaskIntoConstraints = false
      
        number3.text = "100"
        number3.font = UIFont(name: "Pirulen", size: 30)!
        number3.textColor = UIColor.whiteColor()
        number3.textAlignment = .Center
        number3.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(number1)
        addSubview(number2)
        addSubview(number3)
        

        label1.text = "DAYS LEFT"
        label1.font = UIFont(name: "Pirulen", size: 8)!
        label1.textColor = UIColor.whiteColor()
        label1.textAlignment = .Center
        label1.translatesAutoresizingMaskIntoConstraints = false

        label2.text = "PROPOSALS"
        label2.font = UIFont(name: "Pirulen", size: 8)!
        label2.textColor = UIColor.whiteColor()
        label2.textAlignment = .Center
        label2.translatesAutoresizingMaskIntoConstraints = false

        label3.text = "% REGISTRATION"
        label3.font = UIFont(name: "Pirulen", size: 8)!
        label3.textColor = UIColor.whiteColor()
        label3.textAlignment = .Center
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(label1)
        addSubview(label2)
        addSubview(label3)
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    func createConstraint(label : UILabel, centerXFactor : CGFloat, centerYConstant : CGFloat)  {
        
        let number2Height = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 60)
        
        let number2Width = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 4/16,
            constant: 0)
        
        let number2CenterX = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: centerXFactor,
            constant: 0)
        
        let number2CenterY = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: centerYConstant)
        
        addConstraint(number2Height)
        addConstraint(number2Width)
        
        addConstraint(number2CenterX)
        addConstraint(number2CenterY)
    }
    
    func applyConstraint() {
        
        self.layoutIfNeeded()
        

        

    
        createConstraint(number1, centerXFactor: 0.25, centerYConstant : 30)
        createConstraint(number2, centerXFactor: 1, centerYConstant : 30)
        createConstraint(number3, centerXFactor: 1.75, centerYConstant : 30)

        
        
        createConstraint(label1, centerXFactor: 0.25, centerYConstant : 60)
        createConstraint(label2, centerXFactor: 1, centerYConstant : 60)
        createConstraint(label3, centerXFactor: 1.75, centerYConstant : 60)

        
        
        
        
        
        
        
        
        
        
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}