//
//  APIManager.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

import Crashlytics



let commonUrl:[String : [String]] = ["Cfp" : ["Cfp"], "StoredResource" : ["StoredResource"]]



class APIManager {
    
    
    class func getSelectedEvent() -> String {
        let defaults = UserDefaults.standard
        if let selectedEvent = defaults.object(forKey: "currentEvent") as? String {
            return selectedEvent
        }
        return ""
    }
    
    class func qrCodeAlreadyScanned() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: "qrCode") as? String {
            return true
        }
        return false
    }
    
    class func clearQrCode() {
        let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: "qrCode")
    }
    
    
    class func setQrCode(_ str : String) {
        let defaults = UserDefaults.standard
        defaults.setValue(str, forKey: "qrCode")
    }
    
    class func getQrCode() -> String? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "qrCode") as? String

    }
    
    
    
    class func getFallBackData(_ storedResource : StoredResource) -> Data? {
        let testBundle = Bundle.main
        let filePath = testBundle.path(forResource: storedResource.fallback, ofType: "")
 
        if filePath != nil {
            return (try! Data(contentsOf: URL(fileURLWithPath: filePath!)))
        }
        return nil
    }
    
    
    
    
    
    class func getDateFromIndex(_ index : NSInteger, array: NSArray) -> Date {

        if index < array.count  {
            if let dict = array.object(at: index) as? NSDictionary {
                return (dict.object(forKey: "date") as? Date)!
            }
        }
        //error
        return Date()
    }
    
    
    class func getTrackFromIndex(_ index : NSInteger, array: NSArray) -> String {
        
        if index < array.count  {
            if let dict = array.object(at: index) as? NSDictionary {
                return (dict.object(forKey: "label") as? String)!
            }
        }
        //error
        return ""
    }
    
    

    class func handleData(_ inputData : Data, service: AbstractService, storedResource : StoredResource?, etag : String?,completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
        
   
        
        let json = try? JSON(data: inputData)
        let arrayToParse = service.getHelper().prepareArray(json!)
        var arrayHelper = [DataHelperProtocol]()
        
        
        
        
        if let appArray = arrayToParse {
            
            
            
            for appDict in appArray {
                let newHelper = service.getHelper()
                newHelper.feed(appDict)
                arrayHelper.append(newHelper)
            }

            service.updateWithHelper(arrayHelper, completionHandler: completionHandler)
        }
        
        storedResource?.etag = etag ?? ""
       
        
    }
    
    
    class func ok(_ msg:String) {
        //print("OK")
    }
    
    
    class func firstFeed(_ completionHandler: @escaping (_ msg: CallbackProtocol) -> Void, service : AbstractService) {
        singleCommonFeed(completionHandler, service : service)
    }
    
    
    class func logUserCrash() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }

    
    class func singleCommonFeed(_ completionHandler: @escaping (_ msg: CallbackProtocol) -> Void, service : AbstractService) {

        let url = commonUrl[service.getHelper().entityName()]
        
        let testBundle = Bundle.main
        
        for singleUrl in url! {
            
            let filePath = testBundle.path(forResource: singleUrl, ofType: "json")
            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: String.Encoding.utf8.rawValue)) as? String
            if(checkString == nil) {
                // print("should not be empty", terminator: "")
            }
            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath!))
            
            
            self.handleData(data, service: service, storedResource: nil, etag: nil, completionHandler: completionHandler)

        }
        
        
    }
    
    
    
    
    
    
    
    
    class func dataFromImage(_ imageName : String) -> Data? {
        let image = UIImage(named: imageName)
        let nsData = UIImageJPEGRepresentation(image!, 1.0)
        return nsData
    }
    
    
    class func getStringDevice() -> String{
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "phone"
        case .pad:
            return "tablet"
        default :
            return ""
        }
    }
    
    class func getLastFromUrl(_ url : String) -> String {
        let lastPartImageName = url.characters.split{$0 == "/"}.map(String.init)
        
        //check if well formed URL
        if lastPartImageName.count < 2 {
            return ""
        }
        return lastPartImageName[lastPartImageName.count-1]
    }
    
    
    
    
    
    
    
    
    
    class func isCurrentEventEmpty() -> Bool {
        //return getDistinctDays().count == 0
        return false
        
    }
    
    
}

