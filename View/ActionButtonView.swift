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
        
        contentMode = .scaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        addSubview(button)
    }
    
    func setup(_ background : Bool) {
        
        if background {
            backgroundColor = ColorManager.topNavigationBarColor
            layer.cornerRadius = frame.size.width / 2
        }
        
        
        button.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}






