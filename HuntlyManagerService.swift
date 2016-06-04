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
import KeychainAccess


class HuntlyManagerService {
    
    static let sharedInstance = HuntlyManagerService()

    let API = "https://srv.huntlyapp.com:9023"
    //let API = "https://huntly-test.scalac.io"
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
    
    var APP_STORE_LINK = ""
    var SCHEME_URL = ""
    
    var EVENT_ID = -1

    
    func feedEventId(callBack : () -> Void, callbackFailure : () -> Void) {
        
        if EVENT_ID != -1 {
            callBack()
            return
        }
        
        let integration_id = CfpService.sharedInstance.getIntegrationId()
            
            let headers = getHeaders()
        
            Alamofire.request(.GET, "\(API)/deployments", headers : headers)
                .responseJSON { response in
           
                if let JSON = response.result.value {
                        
                    if let arrayJSON = JSON as? NSArray {
                        for singleDeployment in arrayJSON {
                            if singleDeployment.objectForKey("externalId") as? String == integration_id {
                                self.EVENT_ID = (singleDeployment.objectForKey("eventId") as? Int) ?? -1
                                callBack()
                                return
                            }
                        }
                    }
                }
                callbackFailure()
        }
            
        
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
        let keychain = Keychain(service : "com.devoxx")
        if let uuid = keychain["HuntlyService"] {
            return uuid
        }
        let uuid = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        keychain["HuntlyService"] = uuid
        return uuid
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
        
        
        let headers = getHeadersWithUserToken()
        
        
        Alamofire.request(.GET, "\(API)/deployments/\(EVENT_ID)/quests/activity/list", headers : headers)
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

        let headers = getHeadersWithUserToken()
        
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
                                self.postExtraData()
                                handlerSuccess()
                            }
                            else {
                                handlerFailure()
                            }
                            return
                        }
                        handlerFailure()
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )

    
    }

    func updateScore(handlerSuccess : (() -> Void)) {
        
        let headers = getHeadersWithUserToken()
        
        Alamofire.request(.GET, "\(API)/deployments/\(EVENT_ID)/user", headers : headers)
            .responseJSON { response in

                if let JSON = response.result.value {
                    if let pts = JSON.objectForKey("points") as? Int {
                        self.setHuntlyPoints("\(pts)")
                        handlerSuccess()
                    }
                }
        }
    }
    
    
    func postExtraData() {
        
        if APIManager.getQrCode() == nil {
            return
        }
        
        
        let headers = getHeadersWithUserToken()
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
       
        config.HTTPAdditionalHeaders = headers
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        config.timeoutIntervalForResource = 15
        
        let session = NSURLSession(configuration: config)

        

        let params:[String: String] = [
            "key" : "userId",
            "value" : APIManager.getQrCode()! ]
        
        let url = NSURL(string:"\(API)/deployments/\(EVENT_ID)/profile/fill")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject([params], options: NSJSONWritingOptions())
       
        
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    return
                }
            }
            if (error != nil) {
                return
            }
        }
        task.resume()
    }
    
    func storeToken(str : String, handlerSuccess : (Void) -> (), handlerFailure : (Void) -> ())  {
        
        if getToken() != "" {
            completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
            return
        }
        
        let UIdValue = getUUID()
        
        let headers = getHeaders()
        
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
                        if response.result.value == nil {
                            handlerFailure()
                            return
                        }
                        let response = JSON(response.result.value!)
                        self.setToken(response["user"]["token"].string)
                        self.completeQuest(str, handlerSuccess: handlerSuccess, handlerFailure: handlerFailure)
                    }

                case .Failure( _):
                    handlerFailure()
                }
            }
        )
        
    }
    
    func goDeepLink() {
    
        if APP_STORE_LINK == "" {
            
            let headers = getHeaders()
            
            Alamofire.request(.GET, "\(API)/deployments/\(EVENT_ID)/deeplink", headers : headers)
                .responseJSON { response in
                    
                    if let JSON = response.result.value {
    
                        if let appStoreUri = JSON.objectForKey("appStoreUri") as? String, let urlScheme = JSON.objectForKey("deepLink") as? String {
                            self.APP_STORE_LINK = appStoreUri
                            self.SCHEME_URL = urlScheme
                            self.playMoreBtnSelector()
                        }
                    }
            }
        }
        else {
            playMoreBtnSelector()
        }
    
    }
    
    func playMoreBtnSelector() {
    
        let isInstalled = UIApplication.sharedApplication().canOpenURL(NSURL(string:SCHEME_URL)!)
        if isInstalled {
            UIApplication.sharedApplication().openURL(NSURL(string:SCHEME_URL)!)
        }
        else {
            UIApplication.sharedApplication().openURL(NSURL(string:APP_STORE_LINK)!)
        }
    }
    
    func reset() {
        
        FIRST_APP_RUN_QUEST_ID = -1
        VOTE_QUEST_ID = -1
        
        FIRST_APP_RUN_QUEST_POINTS = 0
        VOTE_QUEST_POINTS = 0
        
        APP_STORE_LINK = ""
        SCHEME_URL = ""
        
        EVENT_ID = -1
        
        setHuntlyPoints("0")
        
    }
    
    
    func getHuntlyToken() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("HuntlyAccessToken") as? String ?? ""
    }
    
    func getHeaders() ->  [String : String] {
    
        let headers = ["Authorization": "Basic-Auth: \(getHuntlyToken())"]
        return headers
    }
    
    func getHeadersWithUserToken() ->  [String : String] {
        let headers = ["Authorization": "Basic-Auth: \(getHuntlyToken())",
                       "X-AUTH-TOKEN" : getToken()]
        return headers
    }
}