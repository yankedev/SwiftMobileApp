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



/*
let apiURLS:[String : [String]] = ["Slot" : ["http://cfp.devoxx.be/api/conferences/DV15/schedules/wednesday/","http://cfp.devoxx.be/api/conferences/DV15/schedules/thursday/","http://cfp.devoxx.be/api/conferences/DV15/schedules/friday/"], "TalkType" : ["http://cfp.devoxx.be/api/conferences/DV15/proposalTypes"], "Track" :  ["http://cfp.devoxx.be/api/conferences/DV15/tracks"], "Speaker" :  ["http://cfp.devoxx.be/api/conferences/DV15/speakers"]]
*/



let commonUrl:[String : [String]] = ["StoredResource" : ["StoredResource"], "Cfp" : ["Cfp"]]
let apiURLS:[String : [String]] =  ["Slot" : ["00","01","02","03"], "TalkType" : ["TalkType"], "Track" :  ["Track"], "Speaker" :  ["Speaker"]]
let otherUrls:[String : [String]] = ["Slot" : [], "TalkType" : [], "Track" :  [], "Speaker" :  []]


let allData = ["DV15" : apiURLS, "DevoxxMA2015" : otherUrls, "DevoxxPL2015" : otherUrls, "DevoxxUK2016" : otherUrls, "DevoxxFR2016" : otherUrls]



class APIManager {
    
    static var currentEvent : Cfp!
    
    class func qrCodeAlreadyScanned() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.objectForKey("qrCode") as? String {
            return true
        }
        return false
    }

    
    class func clearQrCode() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(nil, forKey: "qrCode")
    }

    
    class func setQrCode(str : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(str, forKey: "qrCode")
    }
    
    class func doesEtagExistForUrl(url : String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Etag")
        let predicate = NSPredicate(format: "url = %@", url)
        fetchRequest.predicate = predicate
        return checkForEmptyness(context, request: fetchRequest)
    }
    
    class func getEtagForUrl(url : String) ->  Etag {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Etag")
        let predicate = NSPredicate(format: "url = %@", url)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        if items.count == 1 {
            return items[0] as! Etag
        }
        return createEtagForUrl(url)

    }
    
    class func createEtagForUrl(url : String) -> Etag {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Etag", inManagedObjectContext: managedContext)
        let coreData = devoxxApp.Etag(entity: entity!, insertIntoManagedObjectContext: managedContext)
        coreData.url = url
        coreData.value = ""
        save(managedContext)
        return coreData
    }
    
    
    
    class func clearAll(context : NSManagedObjectContext, entity : String) {
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let items = try! context.executeFetchRequest(fetchRequest)
        
        for item in items {
            context.deleteObject(item as! NSManagedObject)
        }
        
        //save(context)
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

    class func isAlreadyLoaded() -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Slot")
        return checkForEmptyness(context, request: fetchRequest)
    }
    
    class func checkForEmptyness(context: NSManagedObjectContext, request : NSFetchRequest) -> Bool {
        let items = try! context.executeFetchRequest(request)
        return items.count > 0
    }
    
    class func save(context:NSManagedObjectContext) {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error)")
        }
    }
    
    class func getDistinctDays() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Slot")
        let predicateEvent = NSPredicate(format: "eventId = %@", APIManager.currentEvent.id!)
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.propertiesToFetch = ["date"]
        fetchRequest.predicate = predicateEvent
        let items = try! context.executeFetchRequest(fetchRequest)
        return items
    }
    
    
    
    class func getAllEvents() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Cfp")
        fetchRequest.resultType = .ManagedObjectResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let items = try! context.executeFetchRequest(fetchRequest)
        return items
    }
    
    class func getDateFromIndex(index : NSInteger, array: NSArray) -> NSDate {
        
        
        
        if index < array.count  {
            if let dict = array.objectAtIndex(index) as? NSDictionary {
                return (dict.objectForKey("date") as? NSDate)!
            }
        }
        //error
        return NSDate()
    }
    
    class func buildFetchRequest(context: NSManagedObjectContext, name: String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: name)
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }
    
    class func getFavorite(type: String, identifier: String, context: NSManagedObjectContext) -> NSFetchRequest {
        let fetchRequest = buildFetchRequest(context, name: "Favorite")
        let predicateId = NSPredicate(format: "id = %@", identifier)
        let predicateType = NSPredicate(format: "type = %@", type)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateId, predicateType])
        return fetchRequest
    }
    
    class func invertFavorite(type: String, identifier: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = getFavorite(type, identifier: identifier, context: context)
        let items = try! context.executeFetchRequest(fetchRequest)
      
        if let fav = items[0] as? Favorite {
            if fav.isFavorited!.boolValue {
                fav.isFavorited = 0
            }
            else {
                fav.isFavorited = 1
            }
            save(context)
            return fav.isFavorited!.boolValue
        }
        return false
    }

    class func isFavorited(type: String, identifier: String) -> Bool {
        
        
        do {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext!
            let fetchRequest = buildFetchRequest(context, name: "Favorite")
            let predicateId = NSPredicate(format: "id = %@", identifier)
            let predicateType = NSPredicate(format: "type = %@", type)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateId, predicateType])
            
            if let items = try context.executeFetchRequest(fetchRequest) as? [Favorite] {
               
                if items.count > 0 {
                    return (items[0].isFavorited?.boolValue)!
                }
            }
            
        } catch let error1 as NSError {
            print(error1)
        }
        
        return false
    }
    

    
       
    class func handleData(inputData : NSData, dataHelper: DataHelperProtocol) {

        let json = JSON(data: inputData)
        
        let arrayToParse = dataHelper.prepareArray(json)

        
      
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!

        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = context.persistentStoreCoordinator
        
        if let appArray = arrayToParse {
            for appDict in appArray {

                let newHelper = dataHelper.copyWithZone(nil) as! DataHelperProtocol
                
                newHelper.feed(appDict)
                newHelper.save(privateContext)
                
            }
        }
        
        APIManager.save(privateContext)
        
    
    }
    
    
    
   
    
    class func sayHi() {
        print("hiiii")
    }
    
    
    
  
    
    
    
    
    // FIRST FEED
    
    class func firstFeed() {
        singleCommonFeed(StoredResourceHelper())
        //singleCommonFeed(ImageHelper())
        singleCommonFeed(CfpHelper())
    }
    
    class func eventFeed() {
        singleFeed(SpeakerHelper())
        singleFeed(SlotHelper())
        singleFeed(TalkTypeHelper())
        singleFeed(TrackHelper())
    }
    
    
    class func singleCommonFeed(helper : DataHelperProtocol) {



        
        let url = commonUrl[helper.entityName()]
        
        let testBundle = NSBundle.mainBundle()
        
        for singleUrl in url! {
            
            let filePath = testBundle.pathForResource(singleUrl, ofType: "json")
            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
            if(checkString == nil) {
                print("should not be empty", terminator: "")
            }
            let data = NSData(contentsOfFile: filePath!)!
            self.handleData(data, dataHelper: helper)
        }
        
        
    }
    
    
    class func innerFeed(bundle : NSBundle, url : String, helper : DataHelperProtocol) {
        let filePath = bundle.pathForResource(url, ofType: "json")
        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
        if(checkString == nil) {
            print("should not be empty", terminator: "")
        }
        let data = NSData(contentsOfFile: filePath!)!
        self.handleData(data, dataHelper: helper)
    }
    
    
    class func singleFeed(helper : DataHelperProtocol) {
        
        
        
        let s = allData[currentEvent!.id!]
        let url = s![helper.typeName()]
        
        
        let testBundle = NSBundle.mainBundle()
        
        for singleUrl in url! {
            innerFeed(testBundle, url: singleUrl, helper: helper)
        }
        
        
    }
    
    
    
    
    
    class func dataFromImage(imageName : String) -> NSData? {
        let image = UIImage(named: imageName)
        let nsData = UIImageJPEGRepresentation(image!, 1.0)
        return nsData
    }
    
    
    
    
    class func getDataFromName(imageName : String) -> NSData {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Image")
        let predicate = NSPredicate(format: "img = %@", imageName)
        fetchRequest.resultType = .ManagedObjectResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        
        if items.count == 0 {
            return NSData()
        }
        
        if let img = items[0] as? Image {
            
            
            //base64EncodedDataWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
            
            
            return img.data
        }
        return NSData()
    }
    
    class func getStringDevice() -> String{
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return "phone"
        case .Pad:
            return "tablet"
        default :
            return ""
        }
    }
  
    class func setEvent(event : Cfp) {
        currentEvent = event
    }
    
    class func getEvent() -> Cfp {
        return currentEvent
    }
    
    class func getSegments() {
        
    }
    
    
    class func debugAllFloors(context : NSManagedObjectContext, withId : String) -> NSArray {
        let fetchRequest = buildFetchRequest(context, name: "Floor")
        let predicate = NSPredicate(format: "id = %@", withId)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        return items
    }
    
    
    class func debugAllDays(context : NSManagedObjectContext) -> NSArray {
        let fetchRequest = buildFetchRequest(context, name: "Day")
        let items = try! context.executeFetchRequest(fetchRequest)
        return items
    }
    
    
    class func debugAllCfp(context : NSManagedObjectContext) -> NSArray {
        let fetchRequest = buildFetchRequest(context, name: "Cfp")
        let items = try! context.executeFetchRequest(fetchRequest)
        return items
    }
    
    class func getLastFromUrl(url : String) -> String {
        let lastPartImageName = url.characters.split{$0 == "/"}.map(String.init)
        
        //check if well formed URL
        if lastPartImageName.count < 2 {
            return ""
        }
        return lastPartImageName[lastPartImageName.count-1]
    }
    
    
    
    class func exists(id : String, leftPredicate: String, entity: String, checkAgainCurrentEvent : Bool) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "\(leftPredicate) = %@", id)
        if checkAgainCurrentEvent {
            let predicateEvent = NSPredicate(format: "cfp.id = %@", APIManager.currentEvent.id!)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateEvent])
        } else {
            fetchRequest.predicate = predicate
        }
        
        let items = try! context.executeFetchRequest(fetchRequest)
        
        return items.count > 0
    }
    
    
    class func exists(id : String, leftPredicate: String, entity: String) -> Bool {
        return exists(id, leftPredicate: leftPredicate, entity: entity, checkAgainCurrentEvent: false)
    }
    
    class func findOne(name : String, value : String, entity: String, context: NSManagedObjectContext) -> FeedableProtocol {
        let fetchRequest = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "\(name) = %@", value)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        
        return items[0] as! FeedableProtocol
    }
    
    
    class func isCurrentEventEmpty() -> Bool {
        return getDistinctDays().count == 0

    }
    
   /*
    class func getTalksFromSpeaker(speaker : Speaker) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Talk")
        let predicate = NSPredicate(format: " = %@", id)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)

    }
    */
    
}

