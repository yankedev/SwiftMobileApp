//
//  InterfaceController.swift
//  SmartvoxxOnWrist Extension
//
//  Created by Sebastien Arbogast on 23/08/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import WatchKit
import Foundation

class SchedulesController: WKInterfaceController {
    @IBOutlet var activityIndicator: WKInterfaceImage!
    @IBOutlet var table: WKInterfaceTable!
    
    var conference: Conference?
    var schedules: [Schedule]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.activityIndicator.setImageNamed("Activity")
        
        if let context = context as? Conference {
            self.conference = context
        }
    }
    
    override func willActivate() {
        super.willActivate()
        self.activityIndicator.setHidden(false)
        self.activityIndicator.startAnimatingWithImagesInRange(NSMakeRange(0, 30), duration: 1.0, repeatCount: 0)
        
        if let conference = self.conference {
            self.setTitle(conference.conferenceDescription)
            
            DataController.sharedInstance.getSchedulesForConference(conference) { (schedules:[Schedule]) -> (Void) in
                self.schedules = schedules
                self.activityIndicator.stopAnimating()
                self.activityIndicator.setHidden(true)
                
                self.table.setNumberOfRows(self.schedules!.count, withRowType: "schedule")
                for (index,schedule) in self.schedules!.enumerate() {
                    if let row = self.table.rowControllerAtIndex(index) as? ScheduleRowController {
                        row.label.setText(schedule.title!.stringByReplacingOccurrencesOfString(NSLocalizedString("Schedule for ", comment:""), withString: ""))
                    }
                }
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        DataController.sharedInstance.cancelSchedules()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.schedules![rowIndex]
    }
}
