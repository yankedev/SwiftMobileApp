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
    
    var scroll : UITextView!
    var slot : Slot!
    var header: UIImageView!
    var talkTitle : UILabel!
    var talkTrack : UILabel!

   // var speakers: UITableView!
    var addFavoriteButton : UIBarButtonItem!
    var indexPath: NSIndexPath!
    var delegate : DevoxxAppFavoriteDelegate!
    
    
  
    
    override public func viewDidLoad() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        scroll = UITextView()
        scroll.backgroundColor = UIColor.whiteColor()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.whiteColor()
        
        talkTitle = UILabel()
        talkTitle.textAlignment = .Justified
        talkTitle.textColor = UIColor.whiteColor()
        //talkTitle.backgroundColor = UIColor.redColor()
        talkTitle.font = UIFont(name: "Arial", size: 17)
        talkTitle.translatesAutoresizingMaskIntoConstraints = false
        talkTitle.numberOfLines = 2
        

        
        talkTrack = UILabel()
        talkTrack.textAlignment = .Justified
        talkTrack.textColor = UIColor.whiteColor()
        //talkTrack.backgroundColor = UIColor.greenColor()
        talkTrack.font = UIFont(name: "Arial", size: 15)
        talkTrack.translatesAutoresizingMaskIntoConstraints = false
        talkTrack.numberOfLines = 0
        
        
       
        
        let inputImage = UIImage(named: "talk_background.png")
        header = UIImageView(image: inputImage)
        header.contentMode = .ScaleAspectFill
        header.clipsToBounds = true
        header.translatesAutoresizingMaskIntoConstraints = false
        
      
        

        
        
        
        
        let details = GobalDetailView()
        details.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(details)
        
       

        view.addSubview(header)
        view.addSubview(scroll)
        header.addSubview(talkTitle)
        header.addSubview(talkTrack)
        
        
        
        
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
                    multiplier: 1-0.6,
                    constant: 0)
        
                header.addConstraint(talkTitleHeight)
                header.addConstraint(talkTitleTop)
        
                let talkTrackHeight = NSLayoutConstraint(item: talkTrack,
                    attribute: NSLayoutAttribute.Height,
                    relatedBy: NSLayoutRelation.Equal,
                toItem: header,
                    attribute: NSLayoutAttribute.Height,
                    multiplier: 0.2,
                    constant: 0)
        
                let talkTrackTop = NSLayoutConstraint(item: talkTrack,
                        attribute: NSLayoutAttribute.Top,
                        relatedBy: NSLayoutRelation.Equal,
                        toItem: header,
                        attribute: NSLayoutAttribute.Bottom,
                        multiplier: 0.8,
                        constant: 0)
            
            
                    header.addConstraint(talkTrackHeight)
                    header.addConstraint(talkTrackTop)


        
        let views = ["header": header, "scroll" : scroll, "talkTitle" : talkTitle, "talkTrack" : talkTrack, "details" : details]
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[header]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTitle]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkTrack]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[details]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
     
 
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[header(120)]-[details(150)]-[scroll]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
   

        
        
        
        

        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constH3)
        view.addConstraints(constH4)
        view.addConstraints(constH5)
        
        view.addConstraints(constV)
        

        talkTitle.text = slot.talk.title
        talkTrack.text = slot.talk.track
        scroll.text = slot.talk.summary
        //scroll.backgroundColor = UIColor.yellowColor()
        
        
        
        
        
        details.layoutIfNeeded()
       
        details.left.simpleDetailView1.textView.firstInfo.text = "Room"
        details.left.simpleDetailView1.textView.secondInfo.text = slot.roomName
        
        details.left.simpleDetailView2.textView.firstInfo.text = "Format"
        details.left.simpleDetailView2.textView.secondInfo.text = slot.talk.getShortTalkTypeName()
        
       /* if slot.talk.speakers.count == 1 {
            details.left.simpleDetailView3.textView.firstInfo.text = "Presentor"
        }
        else {
            details.left.simpleDetailView3.textView.firstInfo.text = "Presentors"
        }

        details.left.simpleDetailView3.textView.secondInfo.text = slot.talk.getFriendlySpeaker()
        
*/
        
        details.left.simpleDetailView3.textView.firstInfo.text = "Date and time"
        details.left.simpleDetailView3.textView.secondInfo.text = slot.getFriendlyTime()
        
        scroll.font = UIFont(name: "Roboto", size:  15)
        
        scroll.editable = false
        
        
        details.right.dataSource = self
        details.right.delegate = self

       
    }
    
   /* public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        view.layoutIfNeeded()
        let fr = talkDescription.frame
        let newFrame = CGRectMake(fr.origin.x, fr.origin.y, size.width, scroll.frame.height)
        talkDescription.frame = newFrame

    }*/
    
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
    
    
   
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRectMake(0,0,20,1000))
        label.font = UIFont(name: "Roboto", size: 12)
        label.textColor = UIColor.lightGrayColor()
        label.text = "Speakers"
        return label

        
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Speakers"
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slot.talk.speakers.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .None
        }
        
        

        
        let speakerArray = slot.talk.speakers.sortedArrayUsingDescriptors([NSSortDescriptor(key: "firstName", ascending: true)]) as! [Speaker]
        
        cell?.textLabel?.text = speakerArray[indexPath.row].getFullName()
        
        return cell!
        
    }
    
    
   
    
}