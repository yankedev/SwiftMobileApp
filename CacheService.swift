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

class CacheService {
    
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

    class func getCfpEntryPoints() -> Promise<[CfpHelper]> {
        
        return Promise{ fulfill, reject in
            
            //fulfill([CfpHelper]())
            
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

