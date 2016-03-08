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
    
    class func feedSpeaker(url : String, data : NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = APIManager.buildFetchRequest(context, name: "Speaker")
        let predicate = NSPredicate(format: "avatarUrl = %@", url)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        if items.count == 1 {
            let it = items[0] as! Speaker
            it.imgData = data
            APIManager.save(context)
        }

    }
    
    
    class func run_on_background_thread(code: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    
    class func fetchUpdate(url : String?, helper : DataHelperProtocol, completedAction : (msg: String) -> Void) {
        print("I will try to update : \(url)")
        
        
        
        APIDataManager.loadDataFromURL(url!, dataHelper: helper, onSuccess: completedAction, onError: onError)
        
    }

    
    class func fetchSpeakerImg(url : String?, completedAction : (msg: String) -> Void) {
        print("I will try to update : \(url)")
        
        
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
                APIReloadManager.feedSpeaker(url!, data : data!)
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