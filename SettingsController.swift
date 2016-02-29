//
//  SettingsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-29.
//  Copyright © 2016 maximedavid. All rights reserved.
//





import Foundation

import UIKit



public class SettingsController : UITableViewController, UIAlertViewDelegate {
    
    
    
    enum KindOfClear: Equatable {
        
        case NON_SELECTED_TWEETS
        
        case SELECTED_TWEETS
        
        case ALL_TWEETS
        
    }
    
    
    
    enum KindOfSection : Equatable {
        
        case QUICK_ACCESS
        
        case SETTINGS

        
    }
    
    
    
    
    
    let color = UIColor(red: 3/255, green: 166/255, blue: 244/255, alpha: 0.08)
    
    
    
    
    
    let alertView = UIAlertView(title: "Head's up !", message: nil, delegate: nil, cancelButtonTitle: nil)
    
    
    
    
    
    
    
    
    
    
    
    
    
    override public func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        
        
        
        alertView.addButtonWithTitle("Sure !")
        
        alertView.addButtonWithTitle("Oops no !")
        
        
        
        
        
        alertView.delegate = self
        
        
        
        self.navigationItem.title = "Settings"
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == KindOfSection.QUICK_ACCESS.hashValue) {
            return "Quick access"
        }
        if(section == KindOfSection.SETTINGS.hashValue) {
            return "Settings"
        }
        return ""
    }
    
    
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == KindOfSection.QUICK_ACCESS.hashValue) {
            return 3
        }
        
        if(section == KindOfSection.SETTINGS.hashValue)  {
            return 2
        }
        
        return 0
    }
    
    
    
    
    
    
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        /*
        
        
        if(indexPath.section == KindOfSection.FETCH_NUMBER.hashValue) {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setInteger(indexPath.row, forKey: "nbOfTweetsToFetch")
            
            self.tableView.reloadData()
            
        }
            
            
            
        else if(indexPath.section == KindOfSection.CLEAR.hashValue) {
            
            
            
            alertView.tag = indexPath.row
            
            
            
            if(indexPath.row == KindOfClear.NON_SELECTED_TWEETS.hashValue) {
                
                alertView.message = "Are you sure you want to delete \n ALL NON SELECTED \n Tweets ?"
                
            }
                
                
                
            else if(indexPath.row == KindOfClear.SELECTED_TWEETS.hashValue) {
                
                alertView.message = "Are you sure you want to delete \n ALL SELECTED \n Tweets ?"
                
            }
                
                
                
            else {
                
                alertView.message = "Are you sure you want to delete \n ALL Tweets ?"
                
            }
            
            
            
            alertView.show()
            
        }
            
            
            
            
            
        else {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setInteger(indexPath.row, forKey: "shouldLoadImages")
            
            self.tableView.reloadData()
            
        }
        
        
        
        
        */
        
        
    }
    
    
    
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
        }
        
        cell!.textLabel!.font = UIFont(name: "Arial", size: 14)

        if(indexPath.section == KindOfSection.QUICK_ACCESS.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = "Purchase a ticket"
            }

            if(indexPath.row == 1) {
                cell!.textLabel!.text = "Report issue"
            }
            if(indexPath.row == 2) {
                cell!.textLabel!.text = "About"
            }
            
        }
            
        if (indexPath.section == KindOfSection.SETTINGS.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = "Change conference"
            }
                
            if(indexPath.row == 1) {
                cell!.textLabel!.text = "Clear QR Code"
            }
        }
            
        return cell!
    }
    
    
    
    
    
    public func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
        print("\(alertView.tag) -> \(buttonIndex)")
        
        
        
        
        
        
        
    }
    
    
    
    
    
}

/*

func ==(a:Settings.KindOfSection, b:Settings.KindOfSection) -> Bool {

return a.hashValue == b.hashValue

}

*/