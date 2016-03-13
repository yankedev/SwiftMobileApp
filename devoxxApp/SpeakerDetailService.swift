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


class SpeakerDetailService : AbstractService {
    
    static let sharedInstance = SpeakerDetailService()
    
    override init() {
        super.init()
    }
    
    func getSpeakerFromId(id : NSManagedObjectID, completionHandler : (Speaker) -> Void)  {
        
        dispatch_async(dispatch_get_main_queue(),{
            let spk = self.privateManagedObjectContext.objectWithID(id) as! Speaker
            completionHandler(spk)
        })
        
    }
    
    override func getHelper() -> DataHelperProtocol {
        return SpeakerDetailHelper()
    }
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                do {
                    
                    
                    let fetchRequest = NSFetchRequest(entityName: "SpeakerDetail")
                    let predicate = NSPredicate(format: "uuid = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if items.count > 0 {
                        let found = items[0] as! FeedableProtocol
                        (singleHelper as! SpeakerDetailHelper).speaker = (found as! SpeakerDetail).speaker
                        found.feedHelper(singleHelper)
                    }
                    else {
                        print("not found")
                    }
                }
                catch {
                    print("in catch")
                }

            }
            
            self.realSave(completionHandler)
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