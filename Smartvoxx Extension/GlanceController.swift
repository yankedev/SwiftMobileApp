//
//  GlanceController.swift
//  SmartvoxxOnWrist Extension
//
//  Created by Sebastien Arbogast on 23/08/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import WatchKit
import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class GlanceController: WKInterfaceController {
    
    @IBOutlet var headerLabel: WKInterfaceLabel!
    @IBOutlet var subtitleLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var roomLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
    
    var nextFavoriteSlots:[TalkSlot]?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.headerLabel.setText(NSLocalizedString("Next", comment: ""))
    }
    
    override func willActivate() {
        super.willActivate()
        
        self.nextFavoriteSlots = DataController.sharedInstance.getFavoriteTalksAfterDate(Date())
        if let nextFavoriteSlots = self.nextFavoriteSlots, nextFavoriteSlots.count > 0 {
            let now = Date()
            var nextFavoriteSlot:TalkSlot?
            for talkSlot in nextFavoriteSlots {
                if talkSlot.fromTimeMillis?.doubleValue > now.timeIntervalSince1970 * 1000 {
                    nextFavoriteSlot = talkSlot
                    break
                }
            }
            if let nextFavoriteSlot = nextFavoriteSlot {
                self.subtitleLabel.setText(String(format:NSLocalizedString("in %@", comment: ""), nextFavoriteSlot.schedule!.conference!.conferenceDescription!))
                self.titleLabel.setText(nextFavoriteSlot.title)
                
                self.roomLabel.setHidden(false)
                self.dateLabel.setHidden(false)
                self.roomLabel.setText(nextFavoriteSlot.roomName)
                
                let startDate = Date(timeIntervalSince1970: nextFavoriteSlot.fromTimeMillis!.doubleValue / 1000)
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.long
                formatter.timeStyle = DateFormatter.Style.none
                let day = formatter.string(from: startDate)
                self.dateLabel.setText("\(day), \(nextFavoriteSlot.timeRange)")
            } else {
                self.subtitleLabel.setText("")
                self.titleLabel.setText(NSLocalizedString("No more upcoming favorite talk.", comment: ""))
                self.roomLabel.setHidden(true)
                self.dateLabel.setHidden(true)
            }
        } else {
            self.subtitleLabel.setText("")
            self.titleLabel.setText(NSLocalizedString("No more upcoming favorite talk.", comment: ""))
            self.roomLabel.setHidden(true)
            self.dateLabel.setHidden(true)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
