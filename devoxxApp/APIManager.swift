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
    /*
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
*/
    }

    
    class func getMockedObjets(postActionParam postAction :(Void) -> (Void), clear : Bool, dataHelper: DataHelper.Type) {
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        //TODO by entity
        if(clear) {
            self.deleteAll(context)
        }
        
        if(!isEntityEmpty(context, name: dataHelper.entityName())) {
            postAction()
            //return
        }
        
        let testBundle = NSBundle.mainBundle()
        let filePath = testBundle.pathForResource(dataHelper.fileName(), ofType: "json")
        
        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
        
        if(checkString == nil) {
            print("should not be empty", terminator: "")
        }
        
        let data = NSData(contentsOfFile: filePath!)!
        
        self.handleData(data, dataHelper: dataHelper, postAction: postAction)
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
    
    class func handleData(inputData : NSData, dataHelper: DataHelper.Type, postAction : (Void) -> Void) {
        
        let json = JSON(data: inputData)

        let arrayToParse = dataHelper.prepareArray(json)
        
        if let appArray = arrayToParse {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            
            for appDict in appArray {
                
                let fedHelper = dataHelper.feed(appDict)
                let entityName =  dataHelper.entityName()
                
                let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedContext)

                let coreDataObject = CellData(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                coreDataObject.feed(fedHelper!)
            }
            
            self.save(managedContext)
            
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
    
    class func isAlreadyLoaded(context : NSManagedObjectContext, name: String, index : NSInteger) -> Bool {
        let fetchRequest = buildFetchRequest(context, name: name)
        let predicate = NSPredicate(format: "day = %@", getDayFromIndex(index))
        fetchRequest.predicate = predicate
        return checkForEmptyness(context, request: fetchRequest)
    }

    
    class func buildFetchRequest(context: NSManagedObjectContext, name: String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }


    class func isEntityEmpty(context: NSManagedObjectContext, name: String) -> Bool {
        return checkForEmptyness(context, request: buildFetchRequest(context, name: name))
    }
    
    class func checkForEmptyness(context: NSManagedObjectContext, request : NSFetchRequest) -> Bool {
        let items = try! context.executeFetchRequest(request)
        return items.count == 0
    }
    
}

