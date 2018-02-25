//
//  SettingsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-29.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit

open class SettingsController : UITableViewController, UIAlertViewDelegate {
    
    enum KindOfSection : Equatable {
        case quick_ACCESS
        case settings
        case credits
    }
    
    fileprivate struct SectionNameString {
        struct QuickAccess {
            static let title = NSLocalizedString("Quick access", comment: "")
            static let purchaseTicket = NSLocalizedString("Purchase a ticket", comment: "")
            static let reportIssue = NSLocalizedString("Report an issue. v", comment: "")
        }
        struct Settings {
            static let title = NSLocalizedString("Settings", comment: "")
            static let changeConference = NSLocalizedString("Change conference", comment: "")
            static let clearQRCode = NSLocalizedString("Clear QR Code", comment: "")
        }
        
        struct Credits {
            static let title = NSLocalizedString("Credits", comment: "")
            static let iosCredits = NSLocalizedString("App by Maxime David\n@xouuox", comment: "")
            static let watchCredits = NSLocalizedString("Apple Watch App by Sébastien Arbogast\n@sarbogast", comment: "")
            static let voxxedCredits = NSLocalizedString("Voxxed Days adaptation by Pasquale Granato\n@sparklinglabs", comment: "")
            static let fullCredits = NSLocalizedString("View full credits", comment: "")
        }
    }
    
    fileprivate struct AlertQRCodeString {
        static let title = NSLocalizedString("Success", comment: "")
        static let content = NSLocalizedString("QRCode has successfully been cleared", comment: "")
        static let okButton = NSLocalizedString("Ok !", comment: "")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if let nav = self.navigationController as? HuntlyNavigationController {
            self.navigationItem.leftBarButtonItem = nav.huntlyLeftButton
        }
        self.view.backgroundColor = UIColor.lightGray
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.navigationItem.title = NSLocalizedString("Settings", comment: "")
    }
    
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == KindOfSection.quick_ACCESS.hashValue) {
            return SectionNameString.QuickAccess.title
        }
        if(section == KindOfSection.settings.hashValue) {
            return SectionNameString.Settings.title
        }
        if(section == KindOfSection.credits.hashValue) {
            return SectionNameString.Credits.title
        }
        return nil
    }
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == KindOfSection.quick_ACCESS.hashValue) {
            return 2
        }
        if(section == KindOfSection.settings.hashValue)  {
            return 2
        }
        if(section == KindOfSection.credits.hashValue)  {
            return 4
        }
        return 0
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == KindOfSection.quick_ACCESS.hashValue {
            if indexPath.row == 0 {
                let url = CfpService.sharedInstance.getRegUrl()
                UIApplication.shared.openURL(URL(string: url!)!)
            }
            if indexPath.row == 1 {
                reportIssue()
            }
    
        }
        
        if indexPath.section == KindOfSection.settings.hashValue {
            if indexPath.row == 0 {
                let defaults = UserDefaults.standard
                defaults.set("", forKey: "currentEvent")
                CfpService.sharedInstance.cfp = nil
                HuntlyManagerService.sharedInstance.reset()
                //CfpService.sharedInstance.clearAll()
                self.parent!.parent?.view!.removeFromSuperview()
                self.parent?.parent?.removeFromParentViewController()
            }
            if indexPath.row == 1 {
                APIManager.clearQrCode()
                let alert = UIAlertController(title: AlertQRCodeString.title, message: AlertQRCodeString.content, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: AlertQRCodeString.okButton, style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if indexPath.section == KindOfSection.credits.hashValue {
            
            if indexPath.row == 3 {
                let url = CfpService.sharedInstance.getCreditUrl()
                UIApplication.shared.openURL(URL(string: url)!)
            }
            
        }
        
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_1")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL_1")
        }
        
        cell!.textLabel!.font = UIFont(name: "Arial", size: 14)
        
        if(indexPath.section == KindOfSection.quick_ACCESS.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = SectionNameString.QuickAccess.purchaseTicket
            }
            
            if(indexPath.row == 1) {
                cell!.textLabel!.text = "\(SectionNameString.QuickAccess.reportIssue)\(getVersion())"
            }
            
        }
        
        if (indexPath.section == KindOfSection.settings.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = SectionNameString.Settings.changeConference
            }
            
            if(indexPath.row == 1) {
                cell!.textLabel!.text = SectionNameString.Settings.clearQRCode
            }
        }
        
        if (indexPath.section == KindOfSection.credits.hashValue) {
            
            if(indexPath.row == 0) {
                cell!.textLabel!.text = SectionNameString.Credits.iosCredits
                cell!.textLabel!.numberOfLines = 2
            }
            
            if(indexPath.row == 1) {
                cell!.textLabel!.text = SectionNameString.Credits.watchCredits
                cell!.textLabel!.numberOfLines = 2
            }
            
            if(indexPath.row == 2) {
                cell!.textLabel!.text = SectionNameString.Credits.voxxedCredits
                cell!.textLabel!.numberOfLines = 2
            }
            
            if(indexPath.row == 3) {
                cell!.textLabel!.text = SectionNameString.Credits.fullCredits
            }
        }
        
        return cell!
    }
    

    func reportIssue() {
        let email = "info@exteso.com"
        let subject = "My%20Voxxed%20-%20Issue%20-%20\(getVersion())"
        let url = URL(string: "mailto:\(email)?subject=\(subject)")
        if url != nil {
            UIApplication.shared.openURL(url!)
        }
        
    }
    
    func getVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return "\(version ?? "").\(buildNumber ?? "")"
    }
    
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == KindOfSection.credits.hashValue) {
            
            if(indexPath.row == 0 || indexPath.row == 1) {
                return 60
            }
        }
        
        return 44
        

    }
    
    
    
    
}
