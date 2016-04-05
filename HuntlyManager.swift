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

    static let API = "https://huntly-devel.scalac.io"
    static let TOKEN_STRING = "huntlyToken"
    static let QUEST_COMPLETED = "questCompleted"
    static let ACTIVITY_COMPLETED = "activityCompleted"
    static let FIRST_APP_RUN_QUEST = "firstAppRun"
    static let POINTS = "points"
    static let VOTE_QUEST = "vote"
    
    class func getEventId() -> Int {
        //to do
        return 7
    }
    
    class func getStoredId(str: String) -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let questId = defaults.objectForKey(str) as? Int {
            return "\(questId)"
        }
        return "-1"
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
    
    class func setHuntlyPoints(pts : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(pts, forKey: POINTS)
    }
    
    class func getHuntlyPoints() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(POINTS) ?? "0"
    }
    
    class func findQuestId(str : String, handlerSuccess : (() -> Void), handlerFailure : (() -> Void)) {
        
        if getStoredId(str) != "-1" {
            completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]
        
        
        Alamofire.request(.GET, "\(API)/deployments/7/quests/activity/list", headers : headers)
            .responseJSON { response in
            
                if let JSON = response.result.value as? NSArray {
                    for jsonPart in JSON {
                        if let actName = jsonPart.objectForKey("activity") as? String {
                            if actName == str {
                                if let questId = jsonPart.objectForKey("questId") as? Int {
                                    let defaults = NSUserDefaults.standardUserDefaults()
                                    defaults.setObject(questId, forKey: str)
                                    completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
                                    return;
                                }
                            }
                        }
                        
                    }
                }
                handlerFailure()
        }
        
    }

    
    
    class func completeQuest(str : String, handlerSuccess : (() -> Void), handlerFailure : (() -> Void)) {
        
        if getStoredId(str) == "-1" {
            findQuestId(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        let questIdValue = getStoredId(str)

        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]
        
        Alamofire.upload(
            .POST,
            "\(API)/quests/activity/complete",
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
                            if response["status"].string == QUEST_COMPLETED || response["status"].string == ACTIVITY_COMPLETED {
                                print("SHOULD SHOW POPUP")
                                handlerSuccess()
                            }
                            else {
                                print("SHOULD NOT SHOW POPUP")
                                handlerFailure()
                            }
                            return
                        }

                        print("SHOULD NOT SHOW POPUP")
                        handlerFailure()
                        
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )

    
    }

    class func updateScore(handlerSuccess : ((String) -> Void)) {
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]
        
        Alamofire.request(.GET, "\(API)/deployments/7/user", headers : headers)
            .responseJSON { response in

                if let JSON = response.result.value {
                    print(JSON)
                    if let pts = JSON.objectForKey("points") as? Int {
                        setHuntlyPoints("\(pts)")
                        handlerSuccess("\(pts)")
                    }
                }
        }
    }
    
    
    class func postExtraData() {
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]

        let parameters = [
            "externalUserId": APIManager.getQrCode() ?? ""
        ]
        
        Alamofire.request(.POST, "\(API)/deployments/7/profile/fill", parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print(JSON)
                }
        }
        
    }
    
    class func storeToken(str : String, handlerSuccess : (Void) -> (), handlerFailure : (Void) -> ())  {
        
        if getToken() != "" {
            completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        let UIdValue = getUUID()
        let platformId = getPlatform()
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ=="]
        
                       //"X-AUTH-TOKEN" : "d0d696d7b68794b371892ecebf11313eef488363db346c226a417f41f87011742c9ccf2e8466129be693b63bf5165e3822f963103994e4e0307272a9f3ebcd0d"]
        
        Alamofire.upload(
            .POST,
            "\(API)/users/login/platform",
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
                        completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
                    }

                case .Failure(let encodingError):
                    handlerFailure()
                }
            }
        )
        
    }
}