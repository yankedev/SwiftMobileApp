//
//  ScheduleControllerInterfaceController.swift
//  Smartvoxx
//
//  Created by Sebastien Arbogast on 13/09/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleController: WKInterfaceController {
    @IBOutlet var activityIndicator: WKInterfaceImage!
    @IBOutlet var table: WKInterfaceTable!
    var schedule: Schedule?
    var dataSource = [AnyObject]()
    fileprivate var notificationObserver:AnyObject?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.activityIndicator.setImageNamed("Activity")

        if let context = context as? Schedule {
            self.schedule = context
        }
    }

    override func willActivate() {
        super.willActivate()
        self.notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "talkFavoriteStatusChanged"), object: nil, queue: nil) { (notification:Notification) in
            self.reloadData()
        }
        reloadData()
    }

    fileprivate func reloadData() {
        if let schedule = self.schedule {
            self.setTitle(schedule.purgedTitle)
            self.activityIndicator.setHidden(false)
            self.activityIndicator.startAnimatingWithImages(in: NSMakeRange(0, 30), duration: 1.0, repeatCount: 0)
            
            DataController.sharedInstance.getSlotsForSchedule(schedule) {
                (slots: [Slot]) -> (Void) in
                self.schedule?.slots = NSOrderedSet(array: slots)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.setHidden(true)
                
                var timeRanges = [String]()
                var rowTypes = [String]()
                self.dataSource = [AnyObject]()
                for slot in slots {
                    if !timeRanges.contains(slot.timeRange) {
                        timeRanges.append(slot.timeRange)
                        rowTypes.append("timerange")
                        self.dataSource.append(slot.timeRange as AnyObject)
                    }
                    
                    rowTypes.append("slot")
                    self.dataSource.append(slot)
                }
                self.table.setRowTypes(rowTypes)
                
                var index = 0
                for item in self.dataSource {
                    if let timeRangeRowController = self.table.rowController(at: index) as? TimeRangeRowController {
                        if let timeRange = item as? String {
                            timeRangeRowController.label.setText(timeRange)
                        }
                    } else if let slotRowController = self.table.rowController(at: index) as? SlotRowController {
                        if let slot = item as? Slot {
                            slotRowController.roomLabel.setText(slot.roomName!)
                            
                            if let breakSlot = item as? BreakSlot {
                                slotRowController.titleLabel.setText(breakSlot.nameEN!)
                                slotRowController.trackSeparator.setBackgroundColor(UIColor.clear)
                                slotRowController.favoriteImage.setHidden(true)
                            } else if let talkSlot = item as? TalkSlot {
                                slotRowController.titleLabel.setText(talkSlot.title!)
                                if talkSlot.track != nil {
                                    slotRowController.trackSeparator.setBackgroundColor(UIColor(rgba: talkSlot.track!.color!))
                                } else {
                                    slotRowController.trackSeparator.setBackgroundColor(UIColor.clear)
                                }
                                
                                if let favorite = talkSlot.favorite?.boolValue, favorite {
                                    slotRowController.favoriteImage.setHidden(false)
                                    slotRowController.favoriteImage.setImageNamed("FavoriteOn")
                                } else {
                                    slotRowController.favoriteImage.setHidden(true)
                                }
                            } else {
                                slotRowController.titleLabel.setText(NSLocalizedString("Coming soon...", comment: ""))
                            }
                        }
                    }
                    index += 1
                }
            }
        }
    }
    
    override func didDeactivate() {
        if let schedule = self.schedule {
            DataController.sharedInstance.cancelSlotsForSchedule(schedule)
        }
        if let notificationObserver = self.notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
        super.didDeactivate()
    }

    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return self.dataSource[rowIndex]
    }
}
