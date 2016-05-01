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
import Unbox

class Slot: NSManagedObject, FeedableProtocol, Unboxable {
    
    @NSManaged var roomName: String
    @NSManaged var slotId: String
    @NSManaged var fromTime: String
    @NSManaged var toTime: String
    @NSManaged var day: String
    @NSManaged var date: NSDate
    @NSManaged var fromTimeMillis: NSNumber
    @NSManaged var cfp: Cfp?
    
    @NSManaged var talk: Talk
    
    
    convenience init() {
        let context = SlotService.sharedInstance.privateManagedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Slot", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    convenience internal required init(unboxer: Unboxer) {
        self.init()
        self.roomName = unboxer.unbox("roomName")
        self.slotId = unboxer.unbox("slotId")
        self.fromTime = unboxer.unbox("fromTime")
        self.toTime = unboxer.unbox("toTime")
        self.day = unboxer.unbox("day")
        
        let savedDate =  NSDate(timeIntervalSince1970: fromTimeMillis.doubleValue/1000)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate:  savedDate)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = dateFormatter.dateFromString("\(components.year)-\(components.month)-\(components.day) 08:00:00")!
    }

    
    
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
    
    
    
    func service() -> AbstractService {
        return SlotService.sharedInstance
    }
    
    
    
    
    
    
}
