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
        
        
        
        
        
        
        
        
        
        class func completion(msg : CallbackProtocol) {
            //TODO
        }
        
        
        
        class func createResource(url : String, completionHandler : (msg: CallbackProtocol) -> Void) {
            let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
            let helper = StoredResourceHelper(url: httpsUrl, etag: "", fallback: "")
            let storedResource = StoredResourceService.sharedInstance
            storedResource.updateWithHelper([helper], completionHandler: completion)
        }
        
        
        class func findResource(url : String) -> StoredResource? {
            let httpsUrl = url.stringByReplacingOccurrencesOfString("http:", withString: "https:")
            let storedResource = StoredResourceService.sharedInstance
            return storedResource.findByUrl(httpsUrl)
        }
        
        
        
        
        
        
        
        
        class func loadDataFromURL(url: String, service : AbstractService, helper : DataHelperProtocol, isCritical : Bool, onSuccess : (value:CallbackProtocol) -> Void, onError: (value:String)->Void) {
            
            return makeRequest(findResource(url)!, service : service, helper : service.getHelper(), isCritical : isCritical, onSuccess: onSuccess, onError: onError)
        }

            
        
        
        
        class func loadDataFromURLS(urls: NSSet?, dataHelper : DataHelperProtocol, isCritical : Bool, onSuccess : (value:CallbackProtocol) -> Void, onError: (value:String)->Void) {
            
            
            for singleUrl in urls! {
                if let singleUrlString = singleUrl as? Day {
                    loadDataFromURL(singleUrlString.url, service: SlotService.sharedInstance, helper : SlotHelper(), isCritical: true, onSuccess: onSuccess, onError: onError)
                }
            }
            
        }
        
        class func makeRequest(storedResource : StoredResource, service : AbstractService, helper : DataHelperProtocol, isCritical : Bool, onSuccess : (value:CallbackProtocol) -> Void, onError: (value:String)->Void) {
            
            
            
            let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            
            let headers = [
                "If-None-Match": storedResource.etag
            ]
            config.HTTPAdditionalHeaders = headers
            config.requestCachePolicy = .ReloadIgnoringLocalCacheData
            config.timeoutIntervalForResource = 5
            
            let session = NSURLSession(configuration: config)
            
            
            
            
            
            
            let task = session.dataTaskWithURL(NSURL(string: storedResource.url)!) {
                data, response1, error in
                
                
                
                
                if let _ = error {
                    
                    //print("No internet for \(storedResource.url)")
                    //print("Store callbal =  \(storedResource.fallback)")
                    
                    
                    if isCritical {
                        
                        //print("critical call")
                        
                        
                        let testBundle = NSBundle.mainBundle()
                        let filePath = testBundle.pathForResource(storedResource.fallback, ofType: "")
                        ////print("check for callback\(storedResource.fallback)")
                        if filePath != nil {
                            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
                            if(checkString == nil) {
                                //print("should not be empty", terminator: "")
                            }
                            let fallbackData = NSData(contentsOfFile: filePath!)!
                            
                            
                            ////print("fallBack data found")
                            
                            APIManager.handleData(fallbackData, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                            
                            
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(),{
                                onError(value: storedResource.url)
                            })
                        }
                        
                        
                        
                        
                    }
                        
                    else {
                        onSuccess(value: CompletionMessage(msg : ""))
                    }
                    
                    
                } else if let httpResponse = response1 as? NSHTTPURLResponse {
                    if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                        
                        ////print("Error code for \(storedResource.url)")
                        
                        let _ = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                        
                        
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
                        else {
                            dispatch_async(dispatch_get_main_queue(),{
                                onSuccess(value: CompletionMessage(msg : ""))
                            })
                        }
                        
                        
                        
                    }
                    else if httpResponse.statusCode == 304 {
                        
                        //print("304 for \(storedResource.url)")
                        
                        
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
                                onSuccess(value: CompletionMessage(msg : ""))
                            })
                        }
                        
                        
                        
                    }
                    else {
                        
                        //print("200 for \(storedResource.url)")
                        
                        APIManager.handleData(data!, service: service, storedResource: storedResource, etag : httpResponse.allHeaderFields["etag"] as? String, completionHandler: onSuccess)
                    }
                }
            }
            
            
            task.resume()
        }
        
        
    }