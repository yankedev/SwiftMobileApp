//
//  CacheService.swift
//  My_Devoxx
//
//  Created by Maxime on 23/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Unbox
import CoreData

class CacheService {
    
    
    class func initItems(cfpId : NSManagedObjectID, service : AbstractService) -> Promise<[NSManagedObject]> {
        return Promise{ fulfill, reject in
            
            var promiseArray = [Promise<[NSManagedObject]>]()
            
            for urlToFetch in service.entryPoint() {
                promiseArray.append(CacheService.fetchFromEntryPoint(cfpId, entryPoint : urlToFetch, service: service))
            }
            
            when(promiseArray).then { (itemsHelper : [[NSManagedObject]]) -> Void in
                
                var items = [NSManagedObject]()
                for subItem in itemsHelper {
                    items.appendContentsOf(subItem)
                }
                 
                CacheService.feed(cfpId, service : service, items : items).then { (itemsHelper : [NSManagedObject]) -> Void in
                    fulfill(itemsHelper)
                }
                }
                .error { error in
                    let castError = error as NSError
                    guard let failedUrl = castError.userInfo["NSErrorFailingURLKey"] as? NSURL else {
                        reject(error)
                        return
                    }
                    guard let fallbackFilePath = self.constructFallback(failedUrl) else {
                        reject(NSError(domain: "Can't find a fallback file path for the following url : \(failedUrl.absoluteString)", code: 0, userInfo: nil))
                        return
                    }
                    let data = NSData(contentsOfFile: fallbackFilePath)
                    do {
                        let speakersHelper:[Speaker] = try UnboxOrThrow(data!)
                        CacheService.feed(cfpId, service : service, items : speakersHelper).then { (speakers : [NSManagedObject]) -> Void in
                            fulfill(speakers)
                        }
                        
                    } catch {
                        reject(NSError(domain: "Impossible to construct cfps from the given fallback file", code: 0, userInfo: nil))
                        return
                    }
                    reject(NSError(domain: "Impossible to construct cfps from the given fallback file", code: 0, userInfo: nil))
            }
        }
    }
    
    
    class func constructFallbackFileName(url : NSURL) -> String {
        return url.lastPathComponent ?? ""
    }
    
    class func constructFallback(url : NSURL) -> String? {
        let fallbackFileName = constructFallbackFileName(url)
        let mainBundle = NSBundle.mainBundle()
        return mainBundle.pathForResource(fallbackFileName, ofType: "")
    }

    
    
    class func feedCfp(cfps : [CfpHelper]) -> Promise<[Cfp]> {
        
        return Promise{ fulfill, reject in
       
            firstly {
                CfpService.sharedInstance.updateWithHelper(cfps)
            }
            .then { (cfps: [Cfp]) -> Void in
                fulfill(cfps)
            }
            .error { error in
                print(error)
                reject(error)
            }
        }
    
    }
    
    class func feed(cfpId : NSManagedObjectID, service : AbstractService, items : [NSManagedObject]) -> Promise<[NSManagedObject]> {
        
        return Promise{ fulfill, reject in
            
            firstly {
                service.update(cfpId, items : items)
                }
                .then { (speakers: [NSManagedObject]) -> Void in
                    fulfill(speakers)
                }
                .error { error in
                    print(error)
                    reject(error)
            }
        }
        
    }

    class func getCfpEntryPoints() -> Promise<[CfpHelper]> {
        
        return Promise{ fulfill, reject in
            
    
            
            let myDevoxxCfpUrlOpt = NSBundle.mainBundle().objectForInfoDictionaryKey("MyDevoxx_CFP_URL") as? String
            
            
            guard let myDevoxxCfpUrl = myDevoxxCfpUrlOpt else {
                reject(NSError(domain: "Can't read MyDevoxx_CFP_URL from info.plist", code: 0, userInfo: nil))
                return
            }
            
            Alamofire.request(.GET, myDevoxxCfpUrl).response { (_, _, data, error) in
                if error == nil {
            
                    do {
                        let cfps : [CfpHelper] = try UnboxOrThrow(data!)
                        fulfill(cfps)
                    } catch {
                        reject(NSError(domain: "Cant't unbox CFP object from the cfp JSON file", code: 0, userInfo: nil))
                        return
                    }
                } else {
                    reject(error!)
                }
            }
        }
    }
    
    
    class func fetchFromEntryPoint(cfpId : NSManagedObjectID, entryPoint : String, service : AbstractService) -> Promise<[NSManagedObject]> {
        
        return Promise{ fulfill, reject in
            
            print("FETCHING \(entryPoint)")

            Alamofire.request(.GET, entryPoint).response { (_, _, data, error) in
                if error == nil && data != nil {
                    
                    let unboxedData = service.unboxData(data!)
                        
                    CacheService.feed(cfpId, service : service, items : unboxedData).then { (itemsHelper : [NSManagedObject]) -> Void in
                        fulfill(unboxedData)
                    }
                    
                } else {
                    reject(error!)
                }
            }
        }
    }


}

