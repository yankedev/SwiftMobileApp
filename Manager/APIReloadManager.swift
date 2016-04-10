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
    
    
       
    class func fetchUpdate(url : String?, service : AbstractService, completedAction : (newHelper: CallbackProtocol) -> Void) {
        
        if ResourceFetcherManager.isAllowedToFetch(url) {
            
            //print("allowed for \(url)")
            
            APIDataManager.loadDataFromURL(url!, service: service, helper: service.getHelper(), loadFromFile: false, onSuccess: completedAction, onError: onError)
            
        }
        else {
            completedAction(newHelper: CompletionMessage(msg : "not allowed"))
        }
    }
    
 
    
    class func fetchImg(url : String?, id : NSManagedObjectID?, service : ImageServiceProtocol, completedAction : (CallbackProtocol) -> Void) {
        
        if id == nil {
            completedAction(CompletionMessage(msg : "id is null"))
        }
 
        if ResourceFetcherManager.isAllowedToFetch(url) {
            
            let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithURL(NSURL(string: url!)!) {
                data, response1, error in
                
                if let _ = error {
                    //print("error for \(url)")
                }
                else {
                    
                    
                    service.updateImageForId(id!, withData : data!, completionHandler: completedAction)
                    
                    
                }
            }
            task.resume()
            
        }
        
        
    }
    
    
        
    
    
    class func onError(value : String) -> Void {
        // print("ERROR")
    }
    
}