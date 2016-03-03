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

    
    class func findEventFromId(context : NSManagedObjectContext) -> Cfp {
        let fetchRequest = APIManager.buildFetchRequest(context, name: "Cfp")
        let predicateEvent = NSPredicate(format: "id = %@", APIManager.currentEvent!.id!)
        fetchRequest.predicate = predicateEvent
        let items = try! context.executeFetchRequest(fetchRequest)
        return items[0] as! Cfp
    }
    
    class func updateCurrentEvent() -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetchRequest = APIManager.buildFetchRequest(context, name: "Cfp")
        let predicateEvent = NSPredicate(format: "id = %@", APIManager.currentEvent!.id!)
        fetchRequest.predicate = predicateEvent
        let items = try! context.executeFetchRequest(fetchRequest)
        
        
        let res = items[0] as! Cfp
        print("get res.count = \(res.days.count)")
        
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
        
       
        
        print("try to fetch \(resource.url)")
        
        
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
        
        
        if let storedResource = APIDataManager.findResource(url) {
            
            if storedResource.hasBeenFedOnce {
                
            }
            else {
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
                print(singleUrlString.url)
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
        
        let session = NSURLSession(configuration: config)
        
        
        

        
        
        let task = session.dataTaskWithURL(NSURL(string: storedResource.url)!) {
            data, response1, error in
            
            
            
            
            if let responseError = error {
              
                print("responseError")
                
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
                        onError(value: storedResource.url)
                    })
                }
                
                
            } else if let httpResponse = response1 as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    
                    print("ni 304 ni 200")
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
                    
                    print("304 detected")
                    
                    if storedResource.fallback == "DV15-friday.json" {
                        print(storedResource.fallback)
                    }
                    
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
                    
                    print("should be 200 \(storedResource.url)")
                    
                                        
                    dispatch_async(dispatch_get_main_queue(),{
                        onSuccess(value: storedResource.url)
                    })
                }
            }
        }

   
        task.resume()
    }
    
}