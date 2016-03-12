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


protocol ImageFeedable {
    func feedImageData(data : NSData)
}

class APIReloadManager {
    
   
    class func run_on_background_thread(code: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    
    class func fetchUpdate(url : String?, helper : DataHelperProtocol, completedAction : (msg: String) -> Void) {
        
        if ResourceFetcherManager.isAllowedToFetch(url) {
        
            //APIDataManager.loadDataFromURL(url!, dataHelper: helper, isCritical : false, onSuccess: completedAction, onError: onError)
            
        }
    }

    
    class func fetchUpdate(url : String?, service : SpeakerService, completedAction : (msg: String) -> Void) {
        
        if ResourceFetcherManager.isAllowedToFetch(url) {
            
            //APIDataManager.loadDataFromURL(url!, service: service, isCritical : false, onSuccess: completedAction, onError: onError)
            
        }
    }

    
    class func fetchImg(url : String?, id : NSManagedObjectID, service : ImageServiceProtocol, completedAction : (msg: String) -> Void) {
        
        if ResourceFetcherManager.isAllowedToFetch(url) {
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.requestCachePolicy = .ReloadIgnoringLocalCacheData
            
            let session = NSURLSession(configuration: config)
            let task = session.dataTaskWithURL(NSURL(string: url!)!) {
                data, response1, error in
                
                if let responseError = error {
                    //print("error for \(url)")
                }
                else {
    
                    
                    service.updateImageForId(id, withData : data!, completionHandler: completedAction)
                    
                    
                }
            }
            task.resume()

        }
        
            
    }

    
        
    
    class func onError(value : String) -> Void {
       // print("ERROR")
    }

}