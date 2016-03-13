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



let commonUrl:[String : [String]] = ["StoredResource" : ["StoredResource"], "Cfp" : ["Cfp"]]



class APIManager {
    
    
    class func qrCodeAlreadyScanned() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let _ = defaults.objectForKey("qrCode") as? String {
            return true
        }
        return false
    }

    
    class func clearQrCode() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(nil, forKey: "qrCode")
    }

    
    class func setQrCode(str : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(str, forKey: "qrCode")
    }
    
  

 
    
   
    
    
       
    class func getDateFromIndex(index : NSInteger, array: NSArray) -> NSDate {
        if index < array.count  {
            if let dict = array.objectAtIndex(index) as? NSDictionary {
                return (dict.objectForKey("date") as? NSDate)!
            }
        }
        //error
        return NSDate()
    }
    
    
    class func getTrackFromIndex(index : NSInteger, array: NSArray) -> String {
  
        if index < array.count  {
            if let dict = array.objectAtIndex(index) as? NSDictionary {
                return (dict.objectForKey("label") as? String)!
            }
        }
        //error
        return ""
    }
    
   
            

    
   
    
    class func handleData(inputData : NSData, service: AbstractService, storedResource : StoredResource?, etag : String?,completionHandler : (msg: String) -> Void) {
        
        print("handle data for \(storedResource?.url)")
       
        let json = JSON(data: inputData)
        let arrayToParse = service.getHelper().prepareArray(json)
        var arrayHelper = [DataHelperProtocol]()
        
        
        
        if let appArray = arrayToParse {
            for appDict in appArray {
                let newHelper = service.getHelper()
                newHelper.feed(appDict)
                arrayHelper.append(newHelper)
            }
            print(appArray.count)
            print(arrayHelper.count)
            service.updateWithHelper(arrayHelper, completionHandler: completionHandler)
        }

        storedResource?.etag = etag ?? ""

    }

    
    class func ok(msg:String) {
        print("OK")
    }

    
    class func firstFeed(completionHandler: (msg: String) -> Void, service : AbstractService) {
        singleCommonFeed(completionHandler, service : service)
    }
    
    class func singleCommonFeed(completionHandler: (msg: String) -> Void, service : AbstractService) {
        
        
        let url = commonUrl[service.getHelper().entityName()]
        
        let testBundle = NSBundle.mainBundle()
        
        for singleUrl in url! {
            
            let filePath = testBundle.pathForResource(singleUrl, ofType: "json")
            let checkString = (try? NSString(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)) as? String
            if(checkString == nil) {
               // print("should not be empty", terminator: "")
            }
            let data = NSData(contentsOfFile: filePath!)!
            
            
            self.handleData(data, service: service, storedResource: nil, etag: nil, completionHandler: completionHandler)
            
            //self.handleData(data, dataHelper: helper, storedResource: nil, etag: nil)
        }
        
        
    }
    
   
    
    
    
    
    
    
    class func dataFromImage(imageName : String) -> NSData? {
        let image = UIImage(named: imageName)
        let nsData = UIImageJPEGRepresentation(image!, 1.0)
        return nsData
    }
    
    
    class func getStringDevice() -> String{
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            return "phone"
        case .Pad:
            return "tablet"
        default :
            return ""
        }
    }
  
    class func getLastFromUrl(url : String) -> String {
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
   
    
    
    /*
    
    
    class func handleData(inputData : NSData, service: AbstractService, storedResource : StoredResource?, etag : String?,completionHandler : (msg: String) -> Void) {
        
        
        
        let json = JSON(data: inputData)
        let arrayToParse = service.getHelper().prepareArray(json)
        
        if let appArray = arrayToParse {
            
            
            
            for appDict in appArray {
                dispatch_group_enter(serviceGroup)
            }
            
            for appDict in appArray {
                let newHelper = service.getHelper()
                newHelper.feed(appDict)
                service.updateWithHelper(newHelper, completionHandler: step)
            }
            service.privateManagedObjectContext.performBlock({
                service.realSave(ok)
            })
            
        }
        
        storedResource?.etag = etag ?? ""
        
        
        
        dispatch_group_notify(serviceGroup,dispatch_get_main_queue(), {
            completionHandler(msg: "GOGOGOOGOGOGOG\(storedResource?.url)")
        })
        
        
    }

    */
}

