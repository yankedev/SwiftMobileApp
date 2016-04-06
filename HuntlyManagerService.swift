//
//  HuntlyManagerService.swift
//  My_Devoxx
//
//  Created by Maxime on 03/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class HuntlyManagerService {
    
    static let sharedInstance = HuntlyManagerService()

    let API = "https://huntly-test.scalac.io"
    let TOKEN_STRING = "huntlyToken"
    let QUEST_COMPLETED = "questCompleted"
    let ACTIVITY_COMPLETED = "activityCompleted"
    let FIRST_APP_RUN_QUEST = "firstAppRun"
    let POINTS = "points"
    let VOTE_QUEST = "vote"
    
    let PLATFORM = "ios"
    
    var FIRST_APP_RUN_QUEST_ID = -1
    var VOTE_QUEST_ID = -1
    
    var FIRST_APP_RUN_QUEST_POINTS = 0
    var VOTE_QUEST_POINTS = 0
    
    
    func getEventId() -> Int {
        return 56
    }
    
    func setStoredId(str: String, value : Int) {
        if(str == FIRST_APP_RUN_QUEST) {
            FIRST_APP_RUN_QUEST_ID = value
        }
        if(str == VOTE_QUEST) {
            VOTE_QUEST_ID = value
        }
    }
    
    func setQuestPoints(str: String, value : Int) {
        if(str == FIRST_APP_RUN_QUEST) {
            FIRST_APP_RUN_QUEST_POINTS = value
        }
        if(str == VOTE_QUEST) {
            VOTE_QUEST_POINTS = value
        }
    }
    
    func getStoredId(str: String) -> Int {
        if(str == FIRST_APP_RUN_QUEST) {
            return FIRST_APP_RUN_QUEST_ID
        }
        if(str == VOTE_QUEST) {
            return VOTE_QUEST_ID
        }
        return -1
    }
    
  
    
    func getUUID() -> String {
        return UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
    }

    func getToken() -> String {
      
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentEventStr = defaults.objectForKey(TOKEN_STRING) as? String {
            return currentEventStr
        }
        return ""
    }
    
    func setToken(token : String?) {
        if token == nil {
            return
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: TOKEN_STRING)
    }
    
    func setHuntlyPoints(pts : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(pts, forKey: POINTS)
    }
    
    func getHuntlyPoints() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(POINTS) ?? "0"
    }
    
    func findQuestId(str : String, handlerSuccess : (() -> Void), handlerFailure : (() -> Void)) {
        
        if getStoredId(str) != -1 {
            completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]
        
        
        Alamofire.request(.GET, "\(API)/deployments/\(getEventId())/quests/activity/list", headers : headers)
            .responseJSON { response in
            
                if let JSON = response.result.value as? NSArray {
                    for jsonPart in JSON {
                        if let actName = jsonPart.objectForKey("activity") as? String {
                            if actName == str {
                                if let questId = jsonPart.objectForKey("questId") as? Int, let points = jsonPart.objectForKey("singleReward") as? Int {
                                    self.setStoredId(str, value: questId)
                                    self.setQuestPoints(str, value: points)
                                    self.completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
                                    return;
                                }
                            }
                        }
                        
                    }
                }
                handlerFailure()
        }
        
    }

    
    
    func completeQuest(str : String, handlerSuccess : (() -> Void), handlerFailure : (() -> Void)) {
        
        if getStoredId(str) == -1 {
            findQuestId(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        let questIdValue = "\(getStoredId(str))"

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
                            if response["status"].string == self.QUEST_COMPLETED || response["status"].string == self.ACTIVITY_COMPLETED {
                                print(response)
                                print(self.getToken())
                                self.postExtraData()
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

    func updateScore(handlerSuccess : ((String) -> Void)) {
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]
        
        Alamofire.request(.GET, "\(API)/deployments/\(getEventId())/user", headers : headers)
            .responseJSON { response in

                if let JSON = response.result.value {
                    print(JSON)
                    if let pts = JSON.objectForKey("points") as? Int {
                        self.setHuntlyPoints("\(pts)")
                        handlerSuccess("\(pts)")
                    }
                }
        }
    }
    
    
    func postExtraData() {
        
        if APIManager.getQrCode() == nil {
            return
        }
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ==",
                       "X-AUTH-TOKEN" : getToken()]

        let parameters = [
            "externalUserId": APIManager.getQrCode() ?? ""
        ]
        print(parameters)
        Alamofire.request(.POST, "\(API)/deployments/\(getEventId())/profile/fill", parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print(JSON)
                }
        }
        
    }
    
    func storeToken(str : String, handlerSuccess : (Void) -> (), handlerFailure : (Void) -> ())  {
        
        if getToken() != "" {
            completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        let UIdValue = getUUID()
        
        let headers = ["Authorization": "Basic-Auth: Z2FtaWNvbjpYNThTZ1ByNQ=="]
        
                       //"X-AUTH-TOKEN" : "d0d696d7b68794b371892ecebf11313eef488363db346c226a417f41f87011742c9ccf2e8466129be693b63bf5165e3822f963103994e4e0307272a9f3ebcd0d"]
        
        Alamofire.upload(
            .POST,
            "\(API)/users/login/platform",
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: UIdValue.dataUsingEncoding(NSUTF8StringEncoding)!, name: "uid")
                multipartFormData.appendBodyPart(data: self.PLATFORM.dataUsingEncoding(NSUTF8StringEncoding)!, name: "platform")
},
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        let response = JSON(response.result.value!)
                        self.setToken(response["user"]["token"].string)
                        self.completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
                    }

                case .Failure(let encodingError):
                    handlerFailure()
                }
            }
        )
        
    }
    
    func playMoreBtnSelector() {
        
        let urlInApp = NSURL(string : "devoxxhuntly://quests_screen")
        let urlAppStore = NSURL(string : "itms-apps://itunes.apple.com/us/app/apple-store/id992261510?mt=8")
        
        let isInstalled = UIApplication.sharedApplication().canOpenURL(urlInApp!)
        if isInstalled {
            UIApplication.sharedApplication().openURL(urlInApp!)
        }
        else {
            UIApplication.sharedApplication().openURL(urlAppStore!)
        }
    }
}