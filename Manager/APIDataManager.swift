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
        
        
        
        class func findEntityFromId<T>(_ id : NSManagedObjectID, inContext context : NSManagedObjectContext) -> T? {
            do {
                if let object = try context.existingObject(with: id) as? T {
                    return object
                }
            } catch _ as NSError {
                //print(error1)
            }
            return nil
        }
        
        
        
        
        
        
        
        
        
        class func completion(_ msg : CallbackProtocol) {
            //TODO
        }
        
        
        
        class func createResource(_ url : String, completionHandler : (_ msg: CallbackProtocol) -> Void) {
            let helper = StoredResourceHelper(url: url, etag: "", fallback: "")
            let storedResource = StoredResourceService.sharedInstance
            storedResource.updateWithHelper([helper], completionHandler: completion)
        }
        
        
        class func findResource(_ url : String) -> StoredResource? {
            let storedResource = StoredResourceService.sharedInstance
            return storedResource.findByUrl(url)
        }
        
        
        
        
        
        
        
        
        class func loadDataFromURL(_ url: String, service : AbstractService, helper : DataHelperProtocol, loadFromFile : Bool, onSuccess : @escaping (_ value:CallbackProtocol) -> Void, onError: @escaping (_ value:String)->Void) {
            
            return makeRequest(findResource(url)!, service : service, helper : service.getHelper(), loadFromFile : loadFromFile, onSuccess: onSuccess, onError: onError)
        }

            
        
        
        
        class func loadDataFromURLS(_ urls: NSOrderedSet?, dataHelper : DataHelperProtocol, loadFromFile : Bool, onSuccess : @escaping (_ value:CallbackProtocol) -> Void, onError: @escaping (_ value:String)->Void) {
            
            
            for singleUrl in urls! {
                if let singleUrlString = singleUrl as? Day {
                    loadDataFromURL(singleUrlString.url, service: SlotService.sharedInstance, helper : SlotHelper(), loadFromFile: false, onSuccess: onSuccess, onError: onError)
                }
            }
            
        }
        
        class func makeRequest(_ storedResource : StoredResource, service : AbstractService, helper : DataHelperProtocol, loadFromFile : Bool, onSuccess : @escaping (_ value:CallbackProtocol) -> Void, onError: @escaping (_ value:String)->Void) {
            
            var urlToFetch = storedResource.url
            if loadFromFile {
                urlToFetch = ""
            }
            
            print("makeRequest "+urlToFetch)
           
            let config = URLSessionConfiguration.default

            config.timeoutIntervalForResource = 15
            
            let session = URLSession(configuration: config)

            let task = session.dataTask(with: URL(string: urlToFetch)!, completionHandler: {
                data, response1, error in
                
                
                
                
                
                if let _ = error {
                    print(error)
                    if loadFromFile {
                       
                        let data = APIManager.getFallBackData(storedResource)
                        
                        if data == nil {
                            DispatchQueue.main.async(execute: {
                                onError(storedResource.url)
                            })
                        }
                        else {
                            APIManager.handleData(data!, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                        }
     
                    }
                        
                    else {
                        onSuccess(CompletionMessage(msg : ""))
                    }
                    
                    
                } else if let httpResponse = response1 as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 && httpResponse.statusCode != 304  {
                        
                        //print("Error code for \(storedResource.url)")
                        
                        let _ = NSError(domain:"devoxx", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                        
                        
                        if loadFromFile {
                            
                            let testBundle = Bundle.main
                            let filePath = testBundle.path(forResource: storedResource.fallback, ofType: "")
                            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: String.Encoding.utf8.rawValue)) as? String
                            if(checkString == nil) {
                                //print("should not be empty", terminator: "")
                            }
                            
                            let fallbackData = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
                            
                            APIManager.handleData(fallbackData, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                            
                        }
                        else {
                            DispatchQueue.main.async(execute: {
                                onSuccess(CompletionMessage(msg : "not 200 nor 304, code = \(httpResponse.statusCode) url = \(storedResource.url)"))
                            })
                        }
                        
                        
                        
                    }
                    else if httpResponse.statusCode == 304 {
                        
                        //print("304 for \(storedResource.url)")
                        
                        
                        if loadFromFile && service.isEmpty() {
                            
                            
                            let data = APIManager.getFallBackData(storedResource)
                            
                            if data == nil {
                                DispatchQueue.main.async(execute: {
                                    onError(storedResource.url)
                                })
                            }
                            else {
                                APIManager.handleData(data!, service: service, storedResource: storedResource, etag: nil, completionHandler: onSuccess)
                            }

                            
                        }
                        else {
                            
                            DispatchQueue.main.async(execute: {
                                onSuccess(CompletionMessage(msg : ""))
                            })
                        }
                        
                        
                        
                    }
                    else {
                        
                        //print("200 for \(storedResource.url)")
                        
                        APIManager.handleData(data!, service: service, storedResource: storedResource, etag : httpResponse.allHeaderFields["etag"] as? String, completionHandler: onSuccess)
                    }
                }
            }) 
            
            
            task.resume()
        }
        
        
    }
