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
    
    
    class func initSpeakers<T : NSManagedObject>(cfpId : NSManagedObjectID) -> Promise<[T]> {
        return Promise{ fulfill, reject in
            CacheService.getSpeakerEntryPoints().then { (speakers : [SpeakerHelper]) -> Void in
                CacheService.feedSpeaker(cfpId, speakers : speakers).then { (speakers : [T]) -> Void in
                    fulfill(speakers)
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
                        let speakersHelper:[SpeakerHelper] = try UnboxOrThrow(data!)
                        CacheService.feedSpeaker(cfpId, speakers : speakersHelper).then { (speakers : [T]) -> Void in
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
    
    class func feedSpeaker<T : NSManagedObject>(cfpId : NSManagedObjectID, speakers : [SpeakerHelper]) -> Promise<[T]> {
        
        return Promise{ fulfill, reject in
            
            firstly {
                SpeakerService.sharedInstance.updateWithHelper(cfpId, helper : speakers)
                }
                .then { (speakers: [T]) -> Void in
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
    
    
    class func getSpeakerEntryPoints() -> Promise<[SpeakerHelper]> {
        
        return Promise{ fulfill, reject in
            
            
            
            let myDevoxxSpeakerUrl = "http://cfp.devoxx.fr/api/conferences/DevoxxFR2016/speakers"
            
            
            Alamofire.request(.GET, myDevoxxSpeakerUrl).response { (_, _, data, error) in
                if error == nil {
                    
                    do {
                        let speakers : [SpeakerHelper] = try UnboxOrThrow(data!)
                        fulfill(speakers)
                    } catch {
                        reject(NSError(domain: "err", code: 0, userInfo: nil))
                        return
                    }
                } else {
                    reject(error!)
                }
            }
        }
    }


}
/*

fetchCfp.json from cache
found ?
    yes -> return the content of the cache
    check if time is OK ->
       yes -> doNothing
       no -> checkForUpdate
    no -> load from file
*/

