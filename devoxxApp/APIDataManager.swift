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

    class func tryToFetch(resource : StoredResource, dataHelper : DataHelperProtocol, completion:(data: NSData?, error: NSError?) -> Void) {
        
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
        loadDataTask.resume()
    }
    
    
    
    class func loadDataFromURL(url: String, dataHelper : DataHelperProtocol) {
        
        let storedResource = APIDataManager.findResource(url)
        
        if storedResource.hasBeenFedOnce {
        
        }
        else {
            tryToFetch(storedResource, dataHelper: dataHelper, completion: handleData)
        }
    }
    
    
}