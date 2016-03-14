//
//  RateTableViewController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-07.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit



public class RateTableViewController : UITableViewController, UIAlertViewDelegate {
    
    
    var rateObject : RatableProtocol!
    
    enum KindOfSection : Equatable {
        case TALK
        case STARS
        case TALK_CONTENT_FEEDBACK
    }
    

    override public func viewDidLoad() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: Selector("cancel"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Vote", style: .Plain, target: self, action: Selector("vote"))
        
    }
    
    
    public func cancel() {
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func vote() {
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == KindOfSection.TALK.hashValue) {
            return ""
        }
        if(section == KindOfSection.STARS.hashValue) {
            return "Select stars"
        }
        if(section == KindOfSection.TALK_CONTENT_FEEDBACK.hashValue) {
            return "Leave a feedback (optional)"
        }
        return ""
    }
    
    

    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == KindOfSection.TALK.hashValue) {
            return 1
        }
        if(section == KindOfSection.STARS.hashValue) {
            return 1
        }
        if(section == KindOfSection.TALK_CONTENT_FEEDBACK.hashValue) {
            return 3
        }
        return 0
    }
    
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        
        if indexPath.section == KindOfSection.TALK.hashValue  {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("TALK")
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "TALK")
            }
            
            cell?.textLabel?.text = rateObject.getTitle()
            cell?.textLabel?.numberOfLines = 0
            
            
            return cell!
            
        }
        
        
        else if indexPath.section == KindOfSection.STARS.hashValue  {
        
            var cell = tableView.dequeueReusableCellWithIdentifier("STAR_CELL")
            
            if cell == nil {
                cell = StarView(style: UITableViewCellStyle.Value1, reuseIdentifier: "STAR_CELL")
            }

            

            return cell!
            
        }
        
        else  {
        
            var cell = tableView.dequeueReusableCellWithIdentifier("FEEDBACK_CELL") as? RateView
            
            if cell == nil {
                cell = RateView(style: UITableViewCellStyle.Value1, reuseIdentifier: "FEEDBACK_CELL")
            }
            
            if indexPath.row == 0 {
                cell!.label.text = "Content feedback :"
            }
            if indexPath.row == 1 {
                cell!.label.text = "Delivery remarks :"
            }
            if indexPath.row == 2 {
                cell!.label.text = "Other :"
            }
            
            
            cell!.textView.text = "Type here..."

            return cell!
            
        }
        
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == KindOfSection.STARS.hashValue  {
            return 60
        }
        
        return 70
    }
    
    
    
    
    
    
    
    
}
