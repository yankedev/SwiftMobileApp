//
//  Cfp.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public protocol EventProtocol  {
    func title() -> String
    func splashImageName() -> String
    func capacityCount() -> String
    func sessionsCount() -> String
    func daysLeft() -> String
    func backgroundImage() -> NSData
}

class Cfp: NSManagedObject, FeedableProtocol, EventProtocol {

    @NSManaged var id: String?
    @NSManaged var confType: String?
    @NSManaged var confDescription: String?
    @NSManaged var venue: String?
    @NSManaged var address: String?
    @NSManaged var country: String?
    @NSManaged var fromDate: String?
    @NSManaged var capacity: String?
    @NSManaged var sessions: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var splashImgURL: String?
    @NSManaged var talkURL: String?
    @NSManaged var hashtag: String?
    @NSManaged var cfpEndpoint: String?
    @NSManaged var regURL: String?
    @NSManaged var backgroundImageData: NSData?
    @NSManaged var floors: NSSet
    @NSManaged var days: NSSet
    @NSManaged var attributes: NSSet
    

    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? CfpHelper  {
            
            id = castHelper.id
            confType = castHelper.confType
            confDescription = castHelper.confDescription
            venue = castHelper.venue
            address = castHelper.address
            talkURL = castHelper.talkURL
            country = castHelper.country
            capacity = castHelper.capacity
            regURL = castHelper.regURL
            fromDate = castHelper.fromDate
            sessions = castHelper.sessions
            cfpEndpoint = castHelper.cfpEndpoint
            latitude = castHelper.latitude
            longitude = castHelper.longitude
            splashImgURL = castHelper.splashImgURL
            hashtag = castHelper.hashtag

            
            let splashImgUrlLastComponent = APIManager.getLastFromUrl(splashImgURL!)

            if let path = NSBundle.mainBundle().pathForResource(splashImgUrlLastComponent, ofType: "") {
                if let data = NSData(contentsOfFile: path) {
                    backgroundImageData = data
                }
            }
            
        }
    }
    
    func daysLeft() -> String {
        
       
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(fromDate!)
        let now = NSDate()
        
        let string = "\(differenceInDaysWithDate(now, secondDate: date!))"
        
        
        return string
        

    }
    
  
    func differenceInDaysWithDate(firstDate : NSDate, secondDate: NSDate) -> Int {
        
        if firstDate.timeIntervalSince1970 >= secondDate.timeIntervalSince1970 {
            return 0
        }
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        let date1 = calendar.startOfDayForDate(firstDate)
        let date2 = calendar.startOfDayForDate(secondDate)
        
        let components = calendar.components(.Day, fromDate: date1, toDate: date2, options: [])
        return components.day
    }
    
    
    func title() -> String {
        return country!
    }
    
    func capacityCount() -> String {
        if capacity == nil {
            return "0"
        }
        return capacity!
    }
    
    func sessionsCount() -> String {
        if sessions == nil {
            return "0"
        }
        return sessions!
    }
    
    func splashImageName() -> String {
        return "splash_btn_\(id!).png"
    }
    
    func numbers() -> Array<Int> {
        return [10, 20, 30]
    }
    
    func backgroundImage() -> NSData {
        return backgroundImageData!
    }
    
    func getImages() -> [Floor] {
        var result = [Floor]()
        for floor in floors  {
            if let realFloor = floor as? Floor  {
                if realFloor.target == APIManager.getStringDevice() {
                    result.append(realFloor)
                }
            }
        }
        return result.sort({ $0.tabpos < $1.tabpos })
    }

}
