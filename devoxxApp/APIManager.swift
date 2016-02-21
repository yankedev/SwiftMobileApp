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




let apiURLS:[String : [String]] = ["Image" : ["ImageMap"], "Cfp" : ["Cfp"], "Slot" : ["00","01","02","03"], "TalkType" : ["TalkType"], "Track" :  ["Track"], "Speaker" :  ["Speaker"]]

class APIManager {
    
    static var currentEvent : Cfp!
    
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
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func getDistinctDays() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = buildFetchRequest(context, name: "Slot")
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.returnsDistinctResults = true
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.propertiesToFetch = ["date"]
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
        if let dict = array.objectAtIndex(index) as? NSDictionary {
            return (dict.objectForKey("date") as? NSDate)!
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

        if let appArray = arrayToParse {
            for appDict in appArray {

                let newHelper = dataHelper.copyWithZone(nil) as! DataHelperProtocol
                
                newHelper.feed(appDict)
                
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = appDelegate.managedObjectContext!
                
                let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
                privateContext.persistentStoreCoordinator = context.persistentStoreCoordinator
                

                newHelper.save(privateContext)
                
                
            }
        }
    
    }
    
    
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        
        let storeEtag = getEtagForUrl(url.absoluteString)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let headers = [
            "If-None-Match": storeEtag.value!
        ]
        //config.HTTPAdditionalHeaders = headers
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        
        let session = NSURLSession(configuration: config)
        
        
        
        
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                }
                else if httpResponse.statusCode == 304 {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code is 304 -> not modified :)"])
                    completion(data: nil, error: statusError)
                }
                else {
                    let etagValue = httpResponse.allHeaderFields["Etag"] as! String
                    storeEtag.value = etagValue
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let context = appDelegate.managedObjectContext!
                    save(context)
                    completion(data: data, error: nil)
                }
            }
        })
        loadDataTask.resume()
    }

    
    class func getMockedObjets(postActionParam postAction :(Void) -> (Void), dataHelper: DataHelperProtocol) {
     
        for url in apiURLS[dataHelper.typeName()]! {
            
            /*
            loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
                if let slotData = data {
                    self.handleData(slotData, dataHelper: dataHelper, postAction: postAction)
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        postAction()
                    }
                }
            })*/
            
            
            let testBundle = NSBundle.mainBundle()
            let filePath = testBundle.pathForResource(url, ofType: "json")
            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
            if(checkString == nil) {
                print("should not be empty", terminator: "")
            }
            let data = NSData(contentsOfFile: filePath!)!
            //self.handleData(data, dataHelper: dataHelper, postAction: postAction)
        }
        
        
    }
    
    
    // FIRST FEED
    
    class func firstFeed() {
        singleFeed(ImageHelper())
        singleFeed(CfpHelper())
        singleFeed(SpeakerHelper())
        singleFeed(SlotHelper())
        singleFeed(TalkTypeHelper())
        singleFeed(TrackHelper())
    }
    
    class func singleFeed(helper : DataHelperProtocol) {
        let url = apiURLS[helper.typeName()]

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
    
    
    
}

