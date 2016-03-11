//
//  Slot.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Slot: NSManagedObject, FeedableProtocol {

    @NSManaged var roomName: String
    @NSManaged var slotId: String
    @NSManaged var fromTime: String
    @NSManaged var toTime: String
    @NSManaged var day: String
    @NSManaged var date: NSDate
    @NSManaged var fromTimeMillis: NSNumber
    @NSManaged var cfp: Cfp?
    
    @NSManaged var talk: Talk

    
    
    func getId() -> NSManagedObject? {
        return nil
    }
    
    
    
    func resetId(id: NSManagedObject?) {
    }
    
    func getFriendlyTime() -> String {
        return ("\(fromTime)-\(toTime)")
    }
    
        
    
  
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? SlotHelper  {
            roomName = castHelper.roomName!
            slotId = castHelper.slotId!
            fromTime = castHelper.fromTime!
            toTime = castHelper.toTime!
            day = castHelper.day!
            fromTimeMillis = castHelper.fromTimeMillis!
            //millis -> sec
            let savedDate =  NSDate(timeIntervalSince1970: fromTimeMillis.doubleValue/1000)
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Year, .Month, .Day], fromDate:  savedDate)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.dateFromString("\(components.year)-\(components.month)-\(components.day) 08:00:00")!

            
            
            
        }
    }
    
   
    
   
    
    
    
    
    
}
