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
    var text : UILabel!
    override public func viewDidLoad() {
        text = UILabel()
        text.backgroundColor = UIColor.purpleColor()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .Justified
        view.addSubview(text)
        
        
        let views = ["talkDescription": text]
        
        let bar = self.navigationController?.navigationBar
        let offset = (bar?.frame.size.height)! + (bar?.frame.origin.y)!
        
        
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[talkDescription]-20-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        self.view.addConstraint(NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: offset + 20))
        
        view.addConstraints(constH)

        
        
        
        text.numberOfLines = 0
        self.view.backgroundColor = UIColor.whiteColor()
       
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.title = talk.title
        text.text = talk.summary
    }
    
}