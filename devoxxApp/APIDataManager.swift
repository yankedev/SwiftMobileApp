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

    
    
    
    class func extractDaysUrlFromConference(data : NSData) -> [String] {
        var arrayToReturn = [String]()
        
        print(data)
        
        let json = JSON(data: data)
        
        let hrefArray = json["links"].array
        for item in hrefArray! {
            arrayToReturn.append(item["href"].string!)
        }
        return arrayToReturn
    }
    
    class func getEntryPointPoint() -> String {
        return "\(APIManager.currentEvent.cfpEndpoint!)/conferences/\(APIManager.currentEvent.id!)/schedules"
    }

    
    
    class func findResource(url : String) -> StoredResource {
        
        
        let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = APIManager.buildFetchRequest(context, name: "StoredResource")
        let predicateEvent = NSPredicate(format: "url = %@", httpsUrl)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.predicate = predicateEvent
        let items = try! context.executeFetchRequest(fetchRequest)
        
        print(items)
        
        
        
        print("Looking for \(httpsUrl) and found ")
        let toReturn = items[0] as! StoredResource
        print(toReturn)
        
        return toReturn
    }
   
    
    class func handleData(data : NSData?, error: NSError?) -> Void {
        print("data = \(data)")
        print("error = \(error)")
    }

    class func tryToFetch(resource : StoredResource, completion:(data: NSData?, error: NSError?) -> Void) {
        
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
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
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
                        
                        let extractedUrl = extractDaysUrlFromConference(fallbackData)
                        print("extracted urls = \(extractedUrl)")
                        
                        
                        for url in extractedUrl {
                            loadDataFromURL2(url)
                        }
                        
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
        loadDataTask.resume()
    }
    
    
    
    
    
    class func tryToFetch2(resource : StoredResource, completion:(data: NSData?, error: NSError?) -> Void) {
        
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
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                }
                else if httpResponse.statusCode == 304 {
                    if resource.hasBeenFedOnce == false {
                        
                        print("304 again")
                        
                        
                        let testBundle = NSBundle.mainBundle()
                        print(resource.fallback)
                        let filePath = testBundle.pathForResource(resource.fallback, ofType: "")
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            print("should not be empty", terminator: "")
                        }
                        let data = NSData(contentsOfFile: filePath!)!
                        APIManager.handleData(data, dataHelper: SlotHelper())
                        
                        
                        
                        
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
        loadDataTask.resume()
    }
    
    
    
    class func loadDataFromURL(url: String) {
        
        let storedResource = APIDataManager.findResource(url)
        
        if storedResource.hasBeenFedOnce {
        
        }
        else {
            tryToFetch(storedResource, completion: handleData)
        }
    }
    
    class func loadDataFromURL2(url: String) {
        
        let storedResource = APIDataManager.findResource(url)
        
        if storedResource.hasBeenFedOnce {
            
        }
        else {
            tryToFetch2(storedResource, completion: handleData)
        }
    }
    
    
    
}