//
//  TalkDetailsController.swift
//  devoxxApp
//
//  Created by maxday on 13.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class TalkDetailsController : UIViewController {
    
    var talk : Talk!
    var text : UITextView!
    override public func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        text = UITextView(frame: CGRectMake(50, 50, 300, 300))
        view.addSubview(text)
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.title = talk.title
        text.text = talk.summary
    }
    
}