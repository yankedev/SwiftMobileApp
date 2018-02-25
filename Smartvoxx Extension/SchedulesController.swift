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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.activityIndicator.setImageNamed("Activity")
        
        if let context = context as? Conference {
            self.conference = context
        }
    }
    
    override func willActivate() {
        super.willActivate()
        self.activityIndicator.setHidden(false)
        self.activityIndicator.startAnimatingWithImages(in: NSMakeRange(0, 30), duration: 1.0, repeatCount: 0)
        
        if let conference = self.conference {
            self.setTitle(conference.conferenceDescription)
            
            DataController.sharedInstance.getSchedulesForConference(conference) { (schedules:[Schedule]) -> (Void) in
                self.schedules = schedules
                self.activityIndicator.stopAnimating()
                self.activityIndicator.setHidden(true)
                
                self.table.setNumberOfRows(self.schedules!.count, withRowType: "schedule")
                for (index,schedule) in self.schedules!.enumerated() {
                    if let row = self.table.rowController(at: index) as? ScheduleRowController {
                        row.label.setText(schedule.purgedTitle)
                    }
                }
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        DataController.sharedInstance.cancelSchedules()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return self.schedules![rowIndex]
    }
}
