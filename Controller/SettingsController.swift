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
    
    enum KindOfSection : Equatable {
        case QUICK_ACCESS
        case SETTINGS
    }
    
    private struct SectionNameString {
        struct QuickAccess {
            static let title = NSLocalizedString("Quick access", comment: "")
            static let purchaseTicket = NSLocalizedString("Purchase a ticket", comment: "")
            static let reportIssue = NSLocalizedString("Report an issue", comment: "")
            static let about = NSLocalizedString("About", comment: "")
        }
        struct Settings {
            static let title = NSLocalizedString("Settings", comment: "")
            static let changeConference = NSLocalizedString("Change conference", comment: "")
            static let clearQRCode = NSLocalizedString("Clear QR Code", comment: "")
        }
    }
    
    private struct AlertQRCodeString {
        static let title = NSLocalizedString("Success", comment: "")
        static let content = NSLocalizedString("QRCode has successfully been cleared", comment: "")
        static let okButton = NSLocalizedString("Ok !", comment: "")
    }
    
    override public func viewDidLoad() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.navigationItem.title = NSLocalizedString("Settings", comment: "")
    }
    
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == KindOfSection.QUICK_ACCESS.hashValue) {
            return SectionNameString.QuickAccess.title
        }
        if(section == KindOfSection.SETTINGS.hashValue) {
            return SectionNameString.Settings.title
        }
        return nil
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
        if indexPath.section == KindOfSection.QUICK_ACCESS.hashValue {
            if indexPath.row == 0 {
                let url = CfpService.sharedInstance.getRegUrl()
                UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
            }
            if indexPath.row == 1 {
                let alert = UIAlertController(title: "Report Issue", message: "go to report issue", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Go", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if indexPath.row == 2 {
                let credits = CreditsController()
                self.navigationController?.pushViewController(credits, animated: true)
            }
        }
        
        if indexPath.section == KindOfSection.SETTINGS.hashValue {
            if indexPath.row == 0 {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject("", forKey: "currentEvent")
                CfpService.sharedInstance.cfp = nil
                //CfpService.sharedInstance.clearAll()
                self.parentViewController!.parentViewController?.view!.removeFromSuperview()
                self.parentViewController?.parentViewController?.removeFromParentViewController()
            }
            if indexPath.row == 1 {
                APIManager.clearQrCode()
                let alert = UIAlertController(title: AlertQRCodeString.title, message: AlertQRCodeString.content, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: AlertQRCodeString.okButton, style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
        }
        
        cell!.textLabel!.font = UIFont(name: "Arial", size: 14)
        
        if(indexPath.section == KindOfSection.QUICK_ACCESS.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = SectionNameString.QuickAccess.purchaseTicket
            }
            
            if(indexPath.row == 1) {
                cell!.textLabel!.text = SectionNameString.QuickAccess.reportIssue
            }
            if(indexPath.row == 2) {
                cell!.textLabel!.text = SectionNameString.QuickAccess.about
            }
            
        }
        
        if (indexPath.section == KindOfSection.SETTINGS.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = SectionNameString.Settings.changeConference
            }
            
            if(indexPath.row == 1) {
                cell!.textLabel!.text = SectionNameString.Settings.clearQRCode
            }
        }
        
        return cell!
    }
    
    
    
    
    
    
    
    
    
    
}
