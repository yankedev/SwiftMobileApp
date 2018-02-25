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
    func feedImageData(_ data : Data)
}

class APIReloadManager {
    
    
       
    class func fetchUpdate(_ url : String?, service : AbstractService, completedAction : @escaping (_ newHelper: CallbackProtocol) -> Void) {
        
        if ResourceFetcherManager.isAllowedToFetch(url) {
            
            //print("allowed for \(url)")
            
            APIDataManager.loadDataFromURL(url!, service: service, helper: service.getHelper(), loadFromFile: false, onSuccess: completedAction, onError: onError)
            
        }
        else {
            completedAction(CompletionMessage(msg : "not allowed"))
        }
    }
    
 
    
    class func fetchImg(_ url : String?, id : NSManagedObjectID?, service : ImageServiceProtocol, completedAction : @escaping (CallbackProtocol) -> Void) {
        
        if id == nil {
            completedAction(CompletionMessage(msg : "id is null"))
        }
 
        if ResourceFetcherManager.isAllowedToFetch(url) {
            
            let config = URLSessionConfiguration.default
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: URL(string: url!)!, completionHandler: {
                data, response1, error in
                
                if let _ = error {
                    //print("error for \(url)")
                }
                else {
                    
                    
                    service.updateImageForId(id!, withData : data!, completionHandler: completedAction)
                    
                    
                }
            }) 
            task.resume()
            
        }
        
        
    }
    
    
        
    
    
    class func onError(_ value : String) -> Void {
        // print("ERROR")
    }
    
}
