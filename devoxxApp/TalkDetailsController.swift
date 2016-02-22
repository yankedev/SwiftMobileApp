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
    var header: UIImageView!
    var talkTitle : UILabel!
    var talkTrack : UILabel!
    var talkDescription : UILabel!
   // var speakers: UITableView!
    var addFavoriteButton : UIBarButtonItem!
    var indexPath: NSIndexPath!
    var delegate : DevoxxAppFavoriteDelegate!
    
    override public func viewDidLoad() {
        scroll = UIScrollView()
        scroll.backgroundColor = UIColor.whiteColor()
        scroll.contentSize = CGSizeMake(320,500)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        talkTitle = UILabel()
        talkTitle.textAlignment = .Justified
        talkTitle.textColor = UIColor.whiteColor()
        //talkTitle.backgroundColor = UIColor.redColor()
        talkTitle.font = UIFont(name: "Arial", size: 20)
        talkTitle.translatesAutoresizingMaskIntoConstraints = false
        talkTitle.numberOfLines = 0
        

        
        talkTrack = UILabel()
        talkTrack.textAlignment = .Justified
        talkTrack.textColor = UIColor.whiteColor()
        //talkTrack.backgroundColor = UIColor.greenColor()
        talkTrack.font = UIFont(name: "Arial", size: 15)
        talkTrack.translatesAutoresizingMaskIntoConstraints = false
        talkTrack.numberOfLines = 0

        
        header = UIImageView(image: UIImage(named: "DevoxxUKHomePage.jpg"))
        header.alpha = 0.8
        header.translatesAutoresizingMaskIntoConstraints = false
        
        
        talkDescription = UILabel(frame: CGRectMake(0,0,320,500))
        talkDescription.numberOfLines = 0
        scroll.addSubview(talkDescription)
   
        view.addSubview(header)
        view.addSubview(scroll)
        header.addSubview(talkTitle)
        header.addSubview(talkTrack)

        
     
        
        
        let views = ["header": header, "scroll" : scroll, "talkTitle" : talkTitle, "talkTrack" : talkTrack]
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[header]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTitle]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTrack]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        let headerHeight = NSLayoutConstraint(item: header,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.33,
            constant: 0)
        
        let scrollTop = NSLayoutConstraint(item: scroll,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: header,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0)
        
        let scrollHeight = NSLayoutConstraint(item: scroll,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1-0.33,
            constant: 0)
        
        view.addConstraint(headerHeight)
        view.addConstraint(scrollTop)
        view.addConstraint(scrollHeight)
        

        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constH3)
        view.addConstraints(constH4)

        
        let talkTitleHeight = NSLayoutConstraint(item: talkTitle,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: header,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.33,
            constant: 0)
        
        let talkTitleTop = NSLayoutConstraint(item: talkTitle,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: header,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1-0.5,
            constant: 0)
        
        header.addConstraint(talkTitleHeight)
        header.addConstraint(talkTitleTop)
        
        let talkTrackHeight = NSLayoutConstraint(item: talkTrack,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: header,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.5-0.33,
            constant: 0)
        
        let talkTrackTop = NSLayoutConstraint(item: talkTrack,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: header,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 0.5+0.33,
            constant: 0)


        header.addConstraint(talkTrackHeight)
        header.addConstraint(talkTrackTop)
       
        talkTitle.text = talk.title
        talkTrack.text = talk.track
        talkDescription.text = talk.summary

       
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