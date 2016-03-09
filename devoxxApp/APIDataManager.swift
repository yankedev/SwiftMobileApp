    //
//  APIDataManager.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-01.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class APIDataManager {

    
    
    
    class func findEventFromId(context : NSManagedObjectContext) -> Cfp? {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context2 = appDelegate.managedObjectContext!
        
        do {

            let fetchRequest = APIManager.buildFetchRequest(context2, name: "Cfp")
            let predicateId = NSPredicate(format: "id = %@", APIManager.currentEvent!.id!)
            fetchRequest.predicate = predicateId
            
            if let items = try context.executeFetchRequest(fetchRequest) as? [Cfp] {
                
                if items.count > 0 {
                    return items[0]
                }
            }
            
        } catch let error1 as NSError {
            print(error1)
        }
        
        return nil
        
    }
    
    
    class func findEntityFromId<T>(id : NSManagedObjectID, context : NSManagedObjectContext) -> T? {
        do {
            if let object = try context.existingObjectWithID(id) as? T {
                return object
            }
        } catch let error1 as NSError {
            print(error1)
        }
        return nil
    }
    
    class func findSpeakerFromId(id : NSManagedObjectID, context : NSManagedObjectContext) -> Speaker? {
        do {
            if let object = try context.existingObjectWithID(id) as? Speaker {
                return object
            }
        } catch let error1 as NSError {
            print(error1)
        }
        return nil
    }
    
    
  
    
    
    class func updateCurrentEvent() -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = APIManager.buildFetchRequest(context, name: "Cfp")
        let predicateEvent = NSPredicate(format: "id = %@", APIManager.currentEvent!.id!)
        fetchRequest.predicate = predicateEvent
        let items = try! context.executeFetchRequest(fetchRequest)
        
        
        let res = items[0] as! Cfp
       
        APIManager.setEvent(items[0] as! Cfp)
    }

    
    class func getEntryPointPoint() -> String {
        return "\(APIManager.currentEvent.cfpEndpoint!)/conferences/\(APIManager.currentEvent.id!)/schedules"
    }
    
    class func getProposalTypes() -> String {
        return "\(APIManager.currentEvent.cfpEndpoint!)/conferences/\(APIManager.currentEvent.id!)/proposalTypes"
    }
    
    class func getTracks() -> String {
        return "\(APIManager.currentEvent.cfpEndpoint!)/conferences/\(APIManager.currentEvent.id!)/tracks"
    }
    
    class func getSpeakerEntryPoint() -> String {
        return "\(APIManager.currentEvent.cfpEndpoint!)/conferences/\(APIManager.currentEvent.id!)/speakers"
    }
    
    
    
    class func createResource(url : String) -> StoredResource? {
        let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let helper = StoredResourceHelper(url: httpsUrl, etag: "", fallback: "")
        helper.save(context)
        APIManager.save(context)
        return findResource(httpsUrl)
    }
    
    
    class func findResource(url : String) -> StoredResource? {
        
        
        let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = APIManager.buildFetchRequest(context, name: "StoredResource")
        let predicateEvent = NSPredicate(format: "url = %@", httpsUrl)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = predicateEvent
        let items = try! context.executeFetchRequest(fetchRequest)
        
        if items.count == 0 {
            return nil
        }
        
        return items[0] as? StoredResource
    }
   
    
    class func handleData(data : NSData?, error: NSError?) -> Void {

    }

    class func tryToFetch(resource : StoredResource, dataHelper : DataHelperProtocol, completion:(data: NSData?, error: NSError?) -> Void, sync : Bool) -> NSURLSessionDataTask{
        
       
        

        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let headers = [
            "If-None-Match": resource.etag
        ]
        
        config.HTTPAdditionalHeaders = headers
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        
        let session = NSURLSession(configuration: config)
        
        
        let loadDataTask = session.dataTaskWithURL(NSURL(string: resource.url)!, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
                
                if resource.hasBeenFedOnce == false {
                    
                    let testBundle = NSBundle.mainBundle()
                    let filePath = testBundle.pathForResource(resource.fallback, ofType: "")
                    let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                    if(checkString == nil) {
                        print("should not be empty", terminator: "")
                    }
                    let fallbackData = NSData(contentsOfFile: filePath!)!
                    
                    APIManager.handleData(fallbackData, dataHelper: dataHelper)
                }

                
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    
                  if resource.hasBeenFedOnce == false {
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(resource.fallback, ofType: "")
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        APIManager.handleData(fallbackData, dataHelper: dataHelper)
                    }

                    
                }
                else if httpResponse.statusCode == 304 {
                    if resource.hasBeenFedOnce == false {
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(resource.fallback, ofType: "")
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        APIManager.handleData(fallbackData, dataHelper: dataHelper)
                    }
                    
                }
                else {
                    let etagValue = httpResponse.allHeaderFields["Etag"] as! String
                    resource.etag = etagValue
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let context = appDelegate.managedObjectContext!
                    APIManager.save(context)
                    completion(data: data, error: nil)
                }
            }
            
        })
        
        
        
        return loadDataTask
        
    }
    
    
    
    
    class func loadDataFromURL(url: String, dataHelper : DataHelperProtocol, onSuccess : (value:String) -> Void, onError: (value:String)->Void) {
        
        
        var res:StoredResource? = nil
        
        if let storedResource = APIDataManager.findResource(url) {
            res = storedResource
        }
        else {
            if let storedResource = APIDataManager.createResource(url) {
                res = storedResource
            }
            else {
                onError(value: url)
            }
        }
        
        
        if let storedResource = res {
            
            if storedResource.hasBeenFedOnce {
                
            }
            else {
                print("REQUEST - \(storedResource.url)")
                return makeRequest(storedResource, dataHelper : dataHelper, onSuccess: onSuccess, onError: onError)
            }
        
        }

        
        else {
            dispatch_async(dispatch_get_main_queue(),{
                onError(value: url)
            })
        }
        
        
    }

    
    class func loadDataFromURLS(urls: NSSet, dataHelper : DataHelperProtocol, onSuccess : (value:String) -> Void, onError: (value:String)->Void) {
        
        for singleUrl in urls {
            if let singleUrlString = singleUrl as? Day {
                loadDataFromURL(singleUrlString.url, dataHelper: dataHelper, onSuccess: onSuccess, onError: onError)
            }
        }
        
    }

    
    
    
    class func makeRequest(storedResource : StoredResource, dataHelper : DataHelperProtocol, onSuccess : (value:String) -> Void, onError: (value:String)->Void){
        
        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let headers = [
            "If-None-Match": storedResource.etag
        ]
        
        config.HTTPAdditionalHeaders = headers
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        config.timeoutIntervalForResource = 5
        
        let session = NSURLSession(configuration: config)
        
        
        

        
        
        let task = session.dataTaskWithURL(NSURL(string: storedResource.url)!) {
            data, response1, error in
            
            
            
            
            if let responseError = error {
              

                
                if storedResource.hasBeenFedOnce == false {
                    
                  
                    
                    let testBundle = NSBundle.mainBundle()
                    let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                    if filePath != nil {
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            APIManager.handleData(fallbackData, dataHelper: dataHelper)
                            onSuccess(value: storedResource.url)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(),{
                            onSuccess(value: storedResource.url)
                        })
                    }
                    
                    
                
                    
                }
                
                else {
                    onSuccess(value: storedResource.url)
                }
                
                
            } else if let httpResponse = response1 as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    

                    if storedResource.hasBeenFedOnce == false {
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            APIManager.handleData(fallbackData, dataHelper: dataHelper)
                        })
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        onSuccess(value: storedResource.url)
                    })
                    
                    
                }
                else if httpResponse.statusCode == 304 {
                    
                  
                    
                    if storedResource.hasBeenFedOnce == false {
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                        
                        
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            APIManager.handleData(fallbackData, dataHelper: dataHelper)
                        })
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        onSuccess(value: storedResource.url)
                    })
                    
                }
                else {
                    
                    APIManager.handleData(data!, dataHelper: dataHelper)
                    
                                        
                    dispatch_async(dispatch_get_main_queue(),{
                        onSuccess(value: storedResource.url)
                    })
                }
            }
        }

   
        task.resume()
    }
    
}