//
//  LeftIconView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-28.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class LeftIconView : UIView {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        //backgroundColor = UIColor.redColor()
        
        addSubview(imageView)
    }
    
    func setup() {
        layoutIfNeeded()
        
        imageView.frame = frame.insetBy(dx: 8, dy: 8);
        imageView.image = UIImage(named: "icon_archisec.png")
        imageView.center =  CGPoint(x: 25, y: 25)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
