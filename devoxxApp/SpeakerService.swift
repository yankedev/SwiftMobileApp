//
//  SpeakerService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum SpeakerStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: SpeakerStoreError, rhs: SpeakerStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class SpeakerService : AbstractService, ImageServiceProtocol {
    
    override init() {
        super.init()
    }
    
    func getSpeakerFromId(id : NSManagedObjectID, completionHandler : (Speaker) -> Void)  {
        
        
        dispatch_async(dispatch_get_main_queue(),{
            let spk = self.privateManagedObjectContext.objectWithID(id) as! Speaker
            print("talkCountBefore\(spk.talks.count)")
            completionHandler(spk)
        })

    
    }
    
    override func getHelper() -> DataHelperProtocol {
        return SpeakerDetailHelper()
    }
    
    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            let fetchRequest = NSFetchRequest(entityName: "SpeakerDetail")
            let predicate = NSPredicate(format: "uuid = %@", helper.getMainId())
            fetchRequest.predicate = predicate
            let items = try! self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
            
            let found = items[0] as! FeedableProtocol
            
            
            
            (helper as! SpeakerDetailHelper).speaker = (found as! SpeakerDetail).speaker
            found.feedHelper(helper)
            self.realSave(completionHandler)
            
            
        }
    
    }
    
    
    func updateImageForId(id : NSManagedObjectID, withData data: NSData, completionHandler : (msg: String) -> Void) {
        print(privateManagedObjectContext)
        
        privateManagedObjectContext.performBlock {
            
            if let obj:ImageFeedable = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
                obj.feedImageData(data)
                
                self.realSave(completionHandler)
                
                
                
                
            }
            
        }
        
    }
    
    
    func fetchSpeakers(completionHandler: (speakers: [Speaker], error: SpeakerStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                let currentCfp:Cfp? = APIDataManager.findEntityFromId(APIManager.currentEvent.objectID, inContext: self.privateManagedObjectContext)
                
                let predicateEvent = NSPredicate(format: "cfp = %@", currentCfp!)
                let fetchRequest = NSFetchRequest(entityName: "Speaker")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.predicate = predicateEvent
                let sortLast = NSSortDescriptor(key: "lastName", ascending: true)
                let sortFirst = NSSortDescriptor(key: "firstName", ascending: true)
                fetchRequest.sortDescriptors = [sortFirst, sortLast]

                
                let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Speaker]
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(speakers: results, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(speakers: [], error: SpeakerStoreError.CannotFetch("Cannot fetch speakers"))
                })
                
            }
        }
    }
    
    
    
}