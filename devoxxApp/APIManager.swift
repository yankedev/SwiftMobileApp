//
//  APIManager.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let topAppURL = "http://cfp.devoxx.be/api/conferences/DV15/schedules/wednesday"

class APIManager {
    
    
    
    class func getMockedSlots(postActionParam postAction :(Void) -> (Void), clear : Bool, index : NSInteger) {
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if(clear) {
            self.deleteAll(managedContext)
        }
        
        if(isAlreadyLoaded(managedContext, index:index)) {
            postAction()
            return
        }
        
        
        let testBundle = NSBundle.mainBundle()
        let filePath = testBundle.pathForResource("0\(index)", ofType: "json")
        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
        
        if(checkString == nil) {
            print("should not be empty", terminator: "")
        }
        
        let data = NSData(contentsOfFile: filePath!)!
        self.handleSlots(data, postAction: postAction);

    }

    
    
    class func getMockedSpeakers(postActionParam postAction :(Void) -> (Void), clear : Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if(clear) {
            self.deleteAll(managedContext)
        }
        
        if(isSpeakerAlreadyLoaded(managedContext)) {
            postAction()
            return
        }
        
        
        let testBundle = NSBundle.mainBundle()
        let filePath = testBundle.pathForResource("speakers", ofType: "json")
        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
        
        if(checkString == nil) {
            print("should not be empty", terminator: "")
        }
        
        let data = NSData(contentsOfFile: filePath!)!
        self.handleSpeakers(data, postAction: postAction);
        
    }

    
    
    
    class func getSlots(postActionParam postAction: (Void) -> (Void)) {
        loadDataFromURL(NSURL(string: topAppURL)!, completion:{(data, error) -> Void in
            if let slotData = data {
                self.handleSlots(slotData, postAction: postAction)
            }
        })
    }
    
    class func handleSlots(slots : NSData, postAction : (Void) -> Void) {
        
        let json = JSON(data: slots)
        
        if let appArray = json["slots"].array {
            
            for appDict in appArray {
                
                let talk = TalkHelper.feed(appDict)
                let slot = SlotHelper.feed(appDict, talk:talk)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext!
                

                let slotEntityName: String = "Slot"
                let slotEntity = NSEntityDescription.entityForName(slotEntityName, inManagedObjectContext: managedContext)
                
                let talkEntityName: String = "Talk"
                let talkEntity = NSEntityDescription.entityForName(talkEntityName, inManagedObjectContext: managedContext)
                
                let coreDataSlotObject = devoxxApp.Slot(entity: slotEntity!, insertIntoManagedObjectContext: managedContext)
                let coreDataTalkObject = devoxxApp.Talk(entity: talkEntity!, insertIntoManagedObjectContext: managedContext)
                
                coreDataSlotObject.fromTime = slot.fromTime
                coreDataSlotObject.roomName = slot.roomName
                coreDataSlotObject.day = slot.day
                
                coreDataTalkObject.title = talk.title
                coreDataTalkObject.summary = talk.summary
                coreDataTalkObject.track = talk.track
                coreDataTalkObject.talkType = talk.talkType
                coreDataTalkObject.trackId = talk.trackId
                coreDataTalkObject.isFavorite = talk.isFavorite
                
                coreDataSlotObject.talk = coreDataTalkObject
                
                self.save(managedContext)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                postAction()
            }
            
        }

    }

    
    class func handleSpeakers(speakers : NSData, postAction : (Void) -> Void) {
        
        let json = JSON(data: speakers)
        
        if let appArray = json.array {
            
            for appDict in appArray {
                
                let speaker = SpeakerHelper.feed(appDict)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext!
                
                
                let speakerEntityName: String = "Speaker"
                let speakerEntity = NSEntityDescription.entityForName(speakerEntityName, inManagedObjectContext: managedContext)
                
                let coreDataSpeakerObject = devoxxApp.Speaker(entity: speakerEntity!, insertIntoManagedObjectContext: managedContext)
                
        
                coreDataSpeakerObject.uuid = speaker.uuid
                coreDataSpeakerObject.lastName = speaker.lastName
                coreDataSpeakerObject.firstName = speaker.firstName
                coreDataSpeakerObject.avatarUrl = speaker.avatarUrl

                self.save(managedContext)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                postAction()
            }
            
        }
        
    }

    
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        loadDataTask.resume()
    }
    
    class func save(context:NSManagedObjectContext) {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func deleteAll(context : NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        var error: NSError?
        
        let items = try! context.executeFetchRequest(fetchRequest)
        
        for item in items {
            context.deleteObject(item as! NSManagedObject)
        }
    }
    
    class func getDayFromIndex(index : NSInteger) -> String {
        if(index == 0) {
            return "monday"
        }
        if(index == 1) {
            return "tuesday"
        }
        if(index == 2) {
            return "wednesday"
        }
        if(index == 3) {
            return "thursday"
        }
        return "friday"
    }
    
    class func isAlreadyLoaded(context : NSManagedObjectContext, index : NSInteger) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "day = %@", getDayFromIndex(index))
        fetchRequest.predicate = predicate
        
        let items = try! context.executeFetchRequest(fetchRequest)
        return items.count > 0
    }
    
    class func isSpeakerAlreadyLoaded(context : NSManagedObjectContext) -> Bool {
        
        let fetchRequest = NSFetchRequest(entityName: "Speaker")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false

        let items = try! context.executeFetchRequest(fetchRequest)
        return items.count > 0
    }
    
    
    
}

