//
//  SpeakerDetailService.swift
//  My_Devoxx
//
//  Created by Maxime on 13/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum SpeakerDetailStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: SpeakerDetailStoreError, rhs: SpeakerDetailStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class SpeakerDetailService : AbstractService, ImageServiceProtocol {
    
    static let sharedInstance = SpeakerDetailService()
    
    override init() {
        super.init()
    }
    
    override func getHelper() -> DataHelperProtocol {
        return SpeakerDetailHelper()
    }
    
    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
                
                
                let fetchRequest = NSFetchRequest(entityName: "SpeakerDetail")
                let predicate = NSPredicate(format: "uuid = %@", helper.getMainId())
                fetchRequest.predicate = predicate
                let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                
                if items.count > 0 {
                    let found = items[0] as! FeedableProtocol
                    (helper as! SpeakerDetailHelper).speaker = (found as! SpeakerDetail).speaker
                    found.feedHelper(helper)
                }
                    
                dispatch_async(dispatch_get_main_queue(),{
                    completionHandler(msg: "ok")
                })
            }
            catch {
                
            }
            
        }
        
    }
    
    
    func updateImageForId(id : NSManagedObjectID, withData data: NSData, completionHandler : (msg: String) -> Void) {
        
        
        privateManagedObjectContext.performBlock {
            
            if let obj:ImageFeedable = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
                obj.feedImageData(data)
                
                dispatch_async(dispatch_get_main_queue(),{
                    completionHandler(msg: "ok")
                })
                
                
                
                
            }
            
        }
        
    }
    
    var currentCfp:Cfp?
    
    override func getCfp() -> Cfp? {
        if currentCfp == nil {
            currentCfp = super.getCfp()
        }
        return currentCfp
    }

    
    func getSpeakerUrl() -> String {
        let cfp = super.getCfp()
        return "\(cfp!.cfpEndpoint!)/conferences/\(cfp!.id!)/speakers"
    }
    
    
    
}