//
//  SimpleDetailView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-24.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class SimpleDetailView : UIView {
    
    let iconView = UIImageView()
    let textView = TopInfoDetailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = UIColor.redColor()
        
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .Top
        iconView.tintColor = ColorManager.grayImageColor
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //iconView.backgroundColor = UIColor.purpleColor()
        //textView.backgroundColor = UIColor.grayColor()
        
              
        
        addSubview(iconView)
        addSubview(textView)
        
        
        
        let views = ["iconView": iconView, "textView" : textView]
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[iconView(50)]-0-[textView]-0-|", options: .AlignAllCenterY, metrics: nil, views: views)
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[iconView]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constV1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)

        addConstraints(constH)
        addConstraints(constV)
        addConstraints(constV1)
        

        
        //self.layoutIfNeeded()
        //textView.configure()
        
        
        
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
