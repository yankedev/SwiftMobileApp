//
//  RateView.swift
//  devoxxApp
//
//  Created by maxday on 07.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class RateView : UIView {
    
    let label = UILabel()
    let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(textView)
        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["label": label, "textView" : textView]
        
        let heightLabel = NSLayoutConstraint(item: label,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.3,
            constant: 0)
        addConstraint(heightLabel)
        
        let textViewTextView = NSLayoutConstraint(item: textView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.7,
            constant: 0)
        addConstraint(textViewTextView)
        
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[label]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let constH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[textView]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        
        let constV0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        addConstraints(constH0)
        addConstraints(constH1)
        addConstraints(constV0)
        
        label.font = UIFont(name: "Roboto", size: 13)
        textView.font = UIFont(name: "Roboto", size: 17)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
