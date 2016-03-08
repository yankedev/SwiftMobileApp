//
//  APIReloadManager.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class APIReloadManager {
    
    class func feedSpeaker(id : NSManagedObjectID, data : NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = context.persistentStoreCoordinator
        if let speaker = APIDataManager.findSpeakerFromId(id, context: context) {
            speaker.imgData = data
            APIManager.save(privateContext)
        }
        
    }
    
    
    class func run_on_background_thread(code: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    
    class func fetchUpdate(url : String?, helper : DataHelperProtocol, completedAction : (msg: String) -> Void) {
       
        
        
        APIDataManager.loadDataFromURL(url!, dataHelper: helper, onSuccess: completedAction, onError: onError)
        
    }

    
    class func fetchSpeakerImg(url : String?, id : NSManagedObjectID, completedAction : (msg: String) -> Void) {
        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithURL(NSURL(string: url!)!) {
            data, response1, error in
            
            if let responseError = error {
                print("error for \(url)")
            }
            else {
                print("fetch for \(url)")
                APIReloadManager.feedSpeaker(id, data : data!)
                dispatch_async(dispatch_get_main_queue(),{
                    completedAction(msg: "ok")
                })
            }
        }
        task.resume()
        
    }

    
    
    class func onError(value : String) -> Void {
        print("ERROR")
    }

}