//
//  HuntlyManager.swift
//  My_Devoxx
//
//  Created by Maxime on 03/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class HuntlyManager {

    static let TOKEN_STRING = "huntlyToken"
    static let QUEST_COMPLETED = "questCompleted"
    
    class func getEventId() -> Int {
        //to do
        return 7
    }
    
    class func getFirstLaunchQuestId() -> String {
        //to do
        return "108"
    }

    class func getUUID() -> String {
        return UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
    }
    
    class func getPlatform() -> String {
        return "ios"
    }
    
    class func getToken() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentEventStr = defaults.objectForKey(TOKEN_STRING) as? String {
            return currentEventStr
        }
        return ""
    }
    
    class func setToken(token : String?) {
        if token == nil {
            return
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: TOKEN_STRING)
    }
    
    class func completeFirstLaunchQuest(handler : (() -> Void)) {
    
        
        let questIdValue = getFirstLaunchQuestId()

        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]
        
        Alamofire.upload(
            .POST,
            "https://huntly-devel.scalac.io/quests/activity/complete",
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: questIdValue.dataUsingEncoding(NSUTF8StringEncoding)!, name: "questId")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.responseJSON { response in
                       
                        guard response.result.value == nil else {
                            let response = JSON(response.result.value!)
                            if response["status"].string == QUEST_COMPLETED {
                                print("SHOULD SHOW POPUP")
                                handler()
                            }
                            else {
                                print("SHOULD NOT SHOW POPUP")
                            }
                            return
                        }

                        print("SHOULD NOT SHOW POPUP")
                       
                        
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )

    
    }
    
    
    
    class func storeToken() {
        
        
        let UIdValue = getUUID()
        let platformId = getPlatform()
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ=="]
        
                       //"X-AUTH-TOKEN" : "d0d696d7b68794b371892ecebf11313eef488363db346c226a417f41f87011742c9ccf2e8466129be693b63bf5165e3822f963103994e4e0307272a9f3ebcd0d"]
        
        Alamofire.upload(
            .POST,
            "https://huntly-devel.scalac.io/users/login/platform",
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: UIdValue.dataUsingEncoding(NSUTF8StringEncoding)!, name: "uid")
                multipartFormData.appendBodyPart(data: platformId.dataUsingEncoding(NSUTF8StringEncoding)!, name: "platform")
},
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let response = JSON(response.result.value!)
                        setToken(response["user"]["token"].string)
                        
                    }

                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
}