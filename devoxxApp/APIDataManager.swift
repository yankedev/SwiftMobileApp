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

    

    class func findEntityFromId<T>(id : NSManagedObjectID, inContext context : NSManagedObjectContext) -> T? {
        do {
            if let object = try context.existingObjectWithID(id) as? T {
                return object
            }
        } catch let error1 as NSError {
            print(error1)
        }
        return nil
    }

    
  
    
    
       
   
    
   
    class func completion(msg : String) {
        //print("OK CREATED")
    }
 
    
    
    class func createResource(url : String, completionHandler : (msg: String) -> Void) {
        let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
        let helper = StoredResourceHelper(url: httpsUrl, etag: "", fallback: "")
        let storedResource = StoredResourceService.sharedInstance
        storedResource.updateWithHelper(helper, completionHandler: completion)
    }
    
    
    class func findResource(url : String) -> StoredResource? {
        let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
        let storedResource = StoredResourceService.sharedInstance
        return storedResource.findByUrl(httpsUrl)
    }
    
   
   
    
   
    
   
    
    class func loadDataFromURL(url: String, service : AbstractService, helper : DataHelperProtocol, isCritical : Bool, onSuccess : (value:String) -> Void, onError: (value:String)->Void) {
        
        print("Make request with : \(url)")
        
        return makeRequest(findResource(url)!, service : service, helper : helper, isCritical : isCritical, onSuccess: onSuccess, onError: onError)
        
    }

    
      
    
    class func loadDataFromURLS(urls: NSSet?, dataHelper : DataHelperProtocol, isCritical : Bool, onSuccess : (value:String) -> Void, onError: (value:String)->Void) {
        

        for singleUrl in urls! {
            if let singleUrlString = singleUrl as? Day {
                loadDataFromURL(singleUrlString.url, service: SlotService.sharedInstance, helper : SlotHelper(), isCritical: true, onSuccess: onSuccess, onError: onError)
            }
        }
        
    }

    class func makeRequest(storedResource : StoredResource, service : AbstractService, helper : DataHelperProtocol, isCritical : Bool, onSuccess : (value:String) -> Void, onError: (value:String)->Void) {
        
        
        
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
                
                print("No internet for \(storedResource.url)")
                print(error)
                
                if isCritical {
                    
                    
                    
                    let testBundle = NSBundle.mainBundle()
                    let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                    if filePath != nil {
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            //print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        
                            
                        APIManager.handleData(fallbackData, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                            
                        
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
                    
                    print("Error code for \(storedResource.url)")
                    
                    let statusError = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    
                    
                    if isCritical {
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            //print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        APIManager.handleData(fallbackData, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        onSuccess(value: storedResource.url)
                    })
                    
                    
                }
                else if httpResponse.statusCode == 304 {
                    
                    print("304 for \(storedResource.url)")
                    
                    
                    if isCritical && service.isEmpty() {
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                        
                        let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                        if(checkString == nil) {
                            //print("should not be empty", terminator: "")
                        }
                        let fallbackData = NSData(contentsOfFile: filePath!)!
                        
                        APIManager.handleData(fallbackData, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                    }
                    else {
                    
                        dispatch_async(dispatch_get_main_queue(),{
                            onSuccess(value: storedResource.url)
                        })
                    }
                    
                    
                    
                }
                else {
                    
                    print("200 for \(storedResource.url)")
                    
                    APIManager.handleData(data!, service: service, storedResource: storedResource, etag : httpResponse.allHeaderFields["etag"] as? String, completionHandler: onSuccess)
                }
            }
        }
        
        
        task.resume()
    }

    
}