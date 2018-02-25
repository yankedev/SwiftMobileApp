//
//  ConferencesController.swift
//  My_Devoxx
//
//  Created by Sebastien Arbogast on 09/04/2016.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import WatchKit
import Foundation


class ConferencesController: WKInterfaceController {
    @IBOutlet var activityIndicator: WKInterfaceImage!
    @IBOutlet var table: WKInterfaceTable!
    
    var conferences: [Conference]?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.activityIndicator.setImageNamed("Activity")
        self.setTitle(NSLocalizedString("Conferences", comment:""))
    }

    override func willActivate() {
        super.willActivate()
        
        self.activityIndicator.setHidden(false)
        self.activityIndicator.startAnimatingWithImages(in: NSMakeRange(0, 30), duration: 1.0, repeatCount: 0)
        
        DataController.sharedInstance.getConferences { (conferences:[Conference]) -> (Void) in
            self.conferences = conferences
            self.activityIndicator.stopAnimating()
            self.activityIndicator.setHidden(true)
            
            self.table.setNumberOfRows(self.conferences!.count, withRowType: "conference")
            for (index,conference) in self.conferences!.enumerated() {
                if let row = self.table.rowController(at: index) as? ConferenceRowController {
                    row.label.setText(conference.conferenceDescription!)
                }
            }
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
        DataController.sharedInstance.cancelConferences()
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return self.conferences![rowIndex]
    }

}
