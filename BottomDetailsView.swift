//
//  BottomDetailsView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-28.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class BottomDetails : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .ScaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.greenColor()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
