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
    
    func applyConstraint() {
        
        self.layoutIfNeeded()
        
        
        let viewDictionary = ["number1":number1, "number2":number2, "number3":number3, "label1":label1, "label2":label2, "label3":label3]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
               
 
        
        let horizontalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[number1(100)]-20-[number2(100)]-20-[number3]-0-|", options: layout, metrics: nil, views: viewDictionary)
        
        
        
        let horizontalContraint1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[label1(100)]-0-[label2(100)]-0-[label3]-0-|", options: layout, metrics: nil, views: viewDictionary)
        
        
        
        let verticalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[number1(100)]-0-[label1]-0-|", options: layout, metrics: nil, views: viewDictionary)

        
        let verticalContraint1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[number2(100)]-0-[label2]-0-|", options: layout, metrics: nil, views: viewDictionary)

        
        let verticalContraint2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[number3(100)]-0-[label3]-0-|", options: layout, metrics: nil, views: viewDictionary)

    
        
        
        
        addConstraints(horizontalContraint0)
        addConstraints(horizontalContraint1)
        
        self.layoutIfNeeded()

        
        addConstraints(verticalContraint0)
        addConstraints(verticalContraint1)
        addConstraints(verticalContraint2)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}