//
//  SpeakerController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class SpeakerController : UIViewController {
    
    override public func viewDidLoad() {
        self.title = "Speakers"
        self.view.backgroundColor = UIColor.whiteColor()
        
        let child = SpeakerTableController()
        addChildViewController(child)
    }
    
}