//
//  SpeakerService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit


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
    
    override func getHelper() -> DataHelperProtocol {
        return SpeakerHelper()
    }
    
    func updateWithHelper<T : NSManagedObject>(cfpId : NSManagedObjectID, helper : [SpeakerHelper]) -> Promise<[T]> {
        
        return Promise{ fulfill, reject in
            
            
            privateManagedObjectContext.performBlock {
                
                let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                
                for singleHelper in helper {
                    do {
                    
                    
                        let fetchRequest = NSFetchRequest(entityName: "Speaker")
                        let predicate = NSPredicate(format: "uuid = %@", singleHelper.getMainId())
                        fetchRequest.predicate = predicate
                        let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                        if items.count == 0 {
                        
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
                    
                        else {
                        
                            if let feedable = items[0] as? FeedableProtocol {
                                feedable.feedHelper(singleHelper)
                            }
                        
                        }
                    
                    
                    
                    }
                    catch {
                        reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                    }
                    
                }
                do {
                    try self.privateManagedObjectContext.save()
                    
                    self.fetchSpeakers(cfpId)
                        .then { (speakers: [T]) -> Void in
                            fulfill(speakers)
                    }
                }
                catch {
                    reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                }
                
            }
        }
        
    }
    
    
    func fetchSpeakers(ids : [NSManagedObjectID], completionHandler: (speakers: [DataHelperProtocol], error: SpeakerStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
           
                
            var speakersArray = [DataHelperProtocol]()
                
            for singleId in ids {
                let obj = self.privateManagedObjectContext.objectWithID(singleId)
                    
                if let objCast = obj as? HelperableProtocol {
                    speakersArray.append(objCast.toHelper())
                }
                    
            }
                
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(speakers: speakersArray, error: nil)
            })
        }
    }
    
   
    
    func fetchSpeakers(completionHandler: (speakers: [DataHelperProtocol], error: SpeakerStoreError?) -> Void) {
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
                
                let resultsHelper = results.map { $0.toHelper() }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(speakers: resultsHelper, error: nil)
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
    
   
    
    
    func updateImageForId(id : NSManagedObjectID, withData data: NSData, completionHandler : ((msg: CallbackProtocol) -> Void)?) {
        
       
        
        privateManagedObjectContext.performBlock {
            
        
            if let obj = self.privateManagedObjectContext.objectWithID(id) as? ImageFeedable {
                obj.feedImageData(data)
                super.saveImage(nil)
            }
            
            self.realSave(completionHandler, img: data)
        }
        
    }

    
    
    
    override func hasBeenAlreadyFed() -> Bool {
        do {
            let fetchRequest = NSFetchRequest(entityName: "Speaker")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            fetchRequest.predicate = predicateEvent
            let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }

    
    func fetchSpeakers<T : NSManagedObject>(cfpId : NSManagedObjectID) -> Promise<[T]> {
        return Promise{ fulfill, reject in
            privateManagedObjectContext.performBlock {
                do {
                    
                    
                    let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                    
                    let predicateEvent = NSPredicate(format: "cfp.id = %@", cfp.id!)
                    let fetchRequest = NSFetchRequest(entityName: "Speaker")
                    fetchRequest.includesSubentities = true
                    fetchRequest.returnsObjectsAsFaults = false
                    fetchRequest.predicate = predicateEvent
                    let sortLast = NSSortDescriptor(key: "lastName", ascending: true)
                    let sortFirst = NSSortDescriptor(key: "firstName", ascending: true)
                    fetchRequest.sortDescriptors = [sortFirst, sortLast]

                    let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [T]
                    fulfill(results)
                } catch {
                    reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                }
            }
        }
    }

    
 

    
  
    
    
}