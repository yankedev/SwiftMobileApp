//
//  SpeakerService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum SpeakerStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: SpeakerStoreError, rhs: SpeakerStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class SpeakerService : AbstractService, ImageServiceProtocol {
    
    static let sharedInstance = SpeakerService()
    
    override init() {
        super.init()
    }
    
    override func getHelper() -> DataHelperProtocol {
        return SpeakerHelper()
    }
    
     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        
      
        
        privateManagedObjectContext.perform {
            for singleHelper in helper {
                do {
                    
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Speaker")
                    let predicate = NSPredicate(format: "uuid = %@", singleHelper.getMainId())
                    let predicateEvent = NSPredicate(format: "cfp.id = %@", CfpService.sharedInstance.getCfpId())
                    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateEvent])
                    let items = try self.privateManagedObjectContext.fetch(fetchRequest)
                    
                    if items.count == 0 {
                        
                        let entity = NSEntityDescription.entity(forEntityName: singleHelper.entityName(), in: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                            
                            coreDataObject.setValue(cfp, forKey: "cfp")
                        }
                        
                        
                        
                        let entity2 = NSEntityDescription.entity(forEntityName: "SpeakerDetail", in: self.privateManagedObjectContext)
                        let coreDataObject2 = SpeakerDetail(entity: entity2!, insertInto: self.privateManagedObjectContext)
                        
                        coreDataObject2.speaker = coreDataObject as! Speaker
                        coreDataObject2.uuid = coreDataObject2.speaker.uuid!
      
                    }
                    
                    else {
                        
                        if let feedable = items[0] as? FeedableProtocol {
                            feedable.feedHelper(singleHelper)
                        }
                        
                     }
                    
                    
                    
                }
                catch {
                    
                }

            }
            
            
            super.realSave(completionHandler)
            
            
        }
    
    }
    
    
    func fetchSpeakers(_ ids : [NSManagedObjectID], completionHandler: @escaping (_ speakers: [DataHelperProtocol], _ error: SpeakerStoreError?) -> Void) {
        privateManagedObjectContext.perform {
           
                
            var speakersArray = [DataHelperProtocol]()
                
            for singleId in ids {
                let obj = self.privateManagedObjectContext.object(with: singleId)
                    
                if let objCast = obj as? HelperableProtocol {
                    speakersArray.append(objCast.toHelper())
                }
                    
            }
                
            DispatchQueue.main.async(execute: {
                completionHandler(speakersArray, nil)
            })
        }
    }
    
   
    
    func fetchSpeakers(_ completionHandler: @escaping (_ speakers: [DataHelperProtocol], _ error: SpeakerStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                
                let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Speaker")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.predicate = predicateEvent
                let sortLast = NSSortDescriptor(key: "lastName", ascending: true)
                let sortFirst = NSSortDescriptor(key: "firstName", ascending: true)
                fetchRequest.sortDescriptors = [sortFirst, sortLast]

                
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [Speaker]
                
                let resultsHelper = results.map { $0.toHelper() }
                
                DispatchQueue.main.async(execute: {
                    completionHandler(resultsHelper, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler([], SpeakerStoreError.cannotFetch("Cannot fetch speakers"))
                })
                
            }
        }
    }
    
    
    
    func getSpeakerUrl() -> String {
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/speakers"
    }
    
   
    
    
    func updateImageForId(_ id : NSManagedObjectID, withData data: Data, completionHandler : ((_ msg: CallbackProtocol) -> Void)?) {
        
       
        
        privateManagedObjectContext.perform {
            
        
            if let obj = self.privateManagedObjectContext.object(with: id) as? ImageFeedable {
                obj.feedImageData(data)
                super.saveImage(nil)
            }
            
            self.realSave(completionHandler, img: data)
        }
        
    }

    
    
    
    override func hasBeenAlreadyFed() -> Bool {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Speaker")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            fetchRequest.predicate = predicateEvent
            let results = try self.privateManagedObjectContext.fetch(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }

    
 

    
  
    
    
}
