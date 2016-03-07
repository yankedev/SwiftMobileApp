//
//  ButtonView.swift
//  devoxxApp
//
//  Created by maxday on 07.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class ButtonView : UIView {
    
    let cancelBtn = UIButton()
    let voteBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let sepView = UIView()
        cancelBtn.setTitle("Cancel", forState: .Normal)
        cancelBtn.backgroundColor = ColorManager.starColor

        voteBtn.setTitle("Vote!", forState: .Normal)
        voteBtn.backgroundColor = ColorManager.starColor
        
        addSubview(cancelBtn)
        addSubview(voteBtn)
        addSubview(sepView)
        
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        voteBtn.translatesAutoresizingMaskIntoConstraints = false
        sepView.translatesAutoresizingMaskIntoConstraints = false
        
         let views = ["cancelBtn" : cancelBtn, "voteBtn" : voteBtn, "sepView" : sepView]
        
        let constV0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[cancelBtn]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let constV1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[voteBtn]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[cancelBtn(80)]-0-[sepView]-0-[voteBtn(80)]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        

        addConstraints(constH0)
        addConstraints(constV0)
        addConstraints(constV1)
        
        
        
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}