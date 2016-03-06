//
//  ActionButtonView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit

class ActionButtonView : UIView {
    
     let button = UIButton()
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .ScaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
       
        

        addSubview(button)
    }
    
    func setup(background : Bool) {
        
        if background {
            backgroundColor = ColorManager.topNavigationBarColor
            layer.cornerRadius = frame.size.width / 2
        }
        
       
        button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        print(button.frame)
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}






