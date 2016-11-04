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
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        
        var foundSpeaker : NSManagedObject!
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                do {
                    
                    
                    let fetchRequest = NSFetchRequest(entityName: "SpeakerDetail")
                    let predicate = NSPredicate(format: "uuid = %@", singleHelper.getMainId())
                    let predicateEvent = NSPredicate(format: "speaker.cfp.id = %@", CfpService.sharedInstance.getCfpId())
                    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateEvent])
              
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as? [SpeakerDetail]
                    
                    if items!.count > 0 {
                        let found = items![0]
                        (singleHelper as! SpeakerDetailHelper).speaker = found.speaker
                        found.feedHelper(singleHelper)
                        foundSpeaker = found.speaker
                    }
                    else {
                       
                    }
                }
                catch {
                   
                }

            }
            
            
            if let objHelperable = foundSpeaker as? HelperableProtocol {
                self.realSave(completionHandler, obj: objHelperable.toHelper())
            }
            else {
                self.realSave(completionHandler)
            }
        }
        
    }
    
  
    
    func getSpeakerUrl() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/speakers"
    }
    
    
 
    
    
}
