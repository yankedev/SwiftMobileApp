//
//  TalkDetailsController.swift
//  devoxxApp
//
//  Created by maxday on 13.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class TalkDetailsController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var scroll : UIScrollView!
    var talk : Talk!
    var desc: UIView!
    var text : UILabel!
    var speakers: UITableView!
    var addFavoriteButton : UIBarButtonItem!
    var indexPath: NSIndexPath!
    var delegate : DevoxxAppFavoriteDelegate!
    
    override public func viewDidLoad() {
        scroll = UIScrollView()
        scroll.backgroundColor = UIColor.yellowColor()
        scroll.contentSize = CGSizeMake(500,500)
        text = UILabel()
        speakers = UITableView(frame: CGRectZero, style: .Plain)
        speakers.dataSource = self
        speakers.delegate = self
        desc = UIView()
        desc.backgroundColor = UIColor.blueColor()
        speakers.backgroundColor = UIColor.redColor()
        //text.backgroundColor = UIColor.purpleColor()
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        speakers.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .Justified
        
        
        //view.addSubview(desc)
        view.addSubview(desc)
        desc.addSubview(text)
        view.addSubview(speakers)
        //scroll.addSubview(speakers)
        
        //view.addSubview(scroll)
        
        
        let views = ["talkDescription": desc, "speakers" : speakers]
        
        //let viewsS = ["scroll": scroll]
        
        
        //let constHS = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: viewsS)
        
        //let constVS = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: viewsS)
        
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkDescription]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[speakers]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[talkDescription]-10-[speakers(80)]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        /*self.view.addConstraint(NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 20))
        */
        
        //view.addConstraints(constHS)
        //view.addConstraints(constVS)

        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constV)

        
        
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.greenColor()
        
        
        
        let widthConstraint = NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: text.superview, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: text.superview, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: text.superview, attribute: NSLayoutAttribute.Top, multiplier: 0.5, constant: 0)
        
        let leftConstraint = NSLayoutConstraint(item: text, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: text.superview, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        
        text.superview!.addConstraint(widthConstraint)
        text.superview!.addConstraint(heightConstraint)
        text.superview!.addConstraint(topConstraint)
        text.superview!.addConstraint(leftConstraint)

        
        
        
        //text.numberOfLines = 0
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
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talk.speakers.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .None
        }
        
        

        
        let speakerArray = talk.speakers.sortedArrayUsingDescriptors([NSSortDescriptor(key: "firstName", ascending: true)]) as! [Speaker]
        
        cell?.textLabel?.text = speakerArray[indexPath.row].getFullName()
        
        return cell!
        
    }
    
    
   
    
}