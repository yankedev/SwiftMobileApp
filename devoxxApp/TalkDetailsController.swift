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
    var addFavoriteButton : UIBarButtonItem!
    var indexPath: NSIndexPath!
    var delegate : DevoxxAppFavoriteDelegate!
    
    override public func viewDidLoad() {
        text = UILabel()
        //text.backgroundColor = UIColor.purpleColor()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .Justified
        view.addSubview(text)
        
        
        
        let views = ["talkDescription": text]
               
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[talkDescription]-20-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        self.view.addConstraint(NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        
        view.addConstraints(constH)

        
        
        
        text.numberOfLines = 0
        self.view.backgroundColor = UIColor.whiteColor()

       
    }
    
    public func clicked() {
       let response = delegate.favorite(indexPath)
        setColor(response)
    }
    
    public func setColor(isFavorited: Bool) {
        if isFavorited {
            addFavoriteButton.tintColor = UIColor.whiteColor()
        }
        else {
            addFavoriteButton.tintColor = UIColor.blackColor()
        }
    }
    
    public func configure() {
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setBackgroundImage(UIImage(named: "StarOn"), forState: UIControlState.Selected)
        button.setBackgroundImage(UIImage(named: "StarOff"), forState: UIControlState.Normal)

        addFavoriteButton = UIBarButtonItem(customView: button)
        addFavoriteButton = UIBarButtonItem(image: UIImage(named: "StarOff"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("clicked"))
        //addFavoriteButton.tintColor = getTintColorFromTag(details.addFavoriteButton.tag)
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.title = talk.title
        text.text = talk.summary
        self.navigationItem.rightBarButtonItem = addFavoriteButton
    }
    
    
    
   
    
}