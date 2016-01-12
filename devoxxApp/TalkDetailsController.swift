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
    
    var scroll : UIScrollView!
    var talk : Talk!
    var desc: UIView!
    var text : UILabel!
    var speakers: UIView!
    var addFavoriteButton : UIBarButtonItem!
    var indexPath: NSIndexPath!
    var delegate : DevoxxAppFavoriteDelegate!
    
    override public func viewDidLoad() {
        scroll = UIScrollView()
        scroll.backgroundColor = UIColor.yellowColor()
        scroll.contentSize = CGSizeMake(500,500)
        text = UILabel()
        speakers = UIView()
        desc = UIView()
        desc.backgroundColor = UIColor.blueColor()
        speakers.backgroundColor = UIColor.redColor()
        //text.backgroundColor = UIColor.purpleColor()
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        speakers.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .Justified
        scroll.addSubview(desc)
        desc.addSubview(text)
        scroll.addSubview(speakers)
        
        view.addSubview(scroll)
        
        
        let views = ["talkDescription": desc, "speakers" : speakers]
        
        let viewsS = ["scroll": scroll]
        
        
        let constHS = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: viewsS)
        
        let constVS = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: viewsS)
        
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkDescription]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[speakers]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[talkDescription(300)]-10-[speakers]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        /*self.view.addConstraint(NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        */
        
        view.addConstraints(constHS)
        view.addConstraints(constVS)

        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constV)

        
        
        
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
        print(talk.speakers.count)
        self.title = talk.title
        text.text = talk.summary
        self.navigationItem.rightBarButtonItem = addFavoriteButton
    }
    
    
    
   
    
}