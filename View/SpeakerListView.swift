//
//  SpeakerListView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-26.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class SpeakerListView : UITableView {
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: .grouped)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.separatorStyle = .none
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
