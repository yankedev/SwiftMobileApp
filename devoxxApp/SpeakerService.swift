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
    
    static let sharedInstance = SpeakerService()
    
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
        return SpeakerHelper()
    }
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        
        privateManagedObjectContext.performBlock {
            for singleHelper in helper {
                do {
                    
                    
                    let fetchRequest = NSFetchRequest(entityName: "Speaker")
                    let predicate = NSPredicate(format: "uuid = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if items.count > 0 {
                        
                    }
                        
                    else {
                        
                        let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                            
                            coreDataObject.setValue(cfp, forKey: "cfp")
                        }
                        
                        
                        
                        let entity2 = NSEntityDescription.entityForName("SpeakerDetail", inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject2 = SpeakerDetail(entity: entity2!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        coreDataObject2.speaker = coreDataObject as! Speaker
                        coreDataObject2.uuid = coreDataObject2.speaker.uuid!
                        
                        
                    }
                    
                    
                    
                }
                catch {
                    
                }

            }
            
            self.realSave(completionHandler)
        }
    
    }
    
    

    
    func fetchSpeakers(completionHandler: (speakers: [Speaker], error: SpeakerStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
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
    
    
    
    func getSpeakerUrl() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/speakers"
    }
    
    
    func updateImageForId(id : NSManagedObjectID, withData data: NSData, completionHandler : (msg: String) -> Void) {
        
        print("update image for speaker detail")
        
        privateManagedObjectContext.performBlock {
            
            if let obj = self.privateManagedObjectContext.objectWithID(id) as? ImageFeedable {
                print("found")
                obj.feedImageData(data)
            }
            
            self.realSave(completionHandler)
        }
        
    }

    
    
    
    
 

    
  
    
    
}