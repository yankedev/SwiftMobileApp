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

class Slot: NSManagedObject, CellDataPrococol, FeedableProtocol, FavoriteProtocol, SearchableItemProtocol {

    @NSManaged var roomName: String
    @NSManaged var slotId: String
    @NSManaged var fromTime: String
    @NSManaged var toTime: String
    @NSManaged var day: String
    @NSManaged var date: NSDate
    @NSManaged var fromTimeMillis: NSNumber
    @NSManaged var eventId: String
    
    @NSManaged var talk: Talk

    
    func getFriendlyTime() -> String {
        return ("\(fromTime)-\(toTime)")
    }
    
    func getForthInformation(useTwitter : Bool) -> String {
        return talk.getFriendlySpeaker(", ", useTwitter : useTwitter)
    }
    
    func getPrimaryImage() -> UIImage? {
        return UIImage(named: talk.getIconFromTrackId())
    }
    
    func getFirstInformation() -> String {
        return talk.title
    }
    
    func getSecondInformation() -> String {
        return roomName
    }
    
    func getThirdInformation() -> String {
        return talk.track
    }
    
    func isSpecial() -> Bool {
        return talk.isBreak
    }
    
    func getColor() -> UIColor? {
        return ColorManager.getColorFromTalkType(talk.talkType)
    }
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? SlotHelper  {
            roomName = castHelper.roomName!
            slotId = castHelper.slotId!
            fromTime = castHelper.fromTime!
            toTime = castHelper.toTime!
            day = castHelper.day!
            fromTimeMillis = castHelper.fromTimeMillis!
            eventId = APIManager.currentEvent.id!
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
    
    func getElement() -> NSManagedObject {
        return talk
    }

    func getIdentifier() -> String {
        return talk.title
    }
    
    func invertFavorite() -> Bool {
        return APIManager.invertFavorite("Talk", identifier: getIdentifier())
    }
    
    func favorited() -> Bool {
        return APIManager.isFavorited("Talk", identifier: getIdentifier())
    }
    
    func isMatching(str : String) -> Bool {
        return getFirstInformation().lowercaseString.containsString(str.lowercaseString)
    }
    
    
    
}
