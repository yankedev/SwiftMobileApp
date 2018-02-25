//
//  SlotHelper.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum SlotStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: SlotStoreError, rhs: SlotStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class SlotService : AbstractService {
    
    static let sharedInstance = SlotService()
    
    override init() {
        super.init()
    }
    
    
    
    
    func fetchCfpDay(_ completionHandler: @escaping (_ : NSArray, _ error: SlotStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Slot")
                let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.returnsDistinctResults = true
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                fetchRequest.propertiesToFetch = ["date"]
                fetchRequest.predicate = predicateEvent
                fetchRequest.shouldRefreshRefetchedObjects = true
                fetchRequest.includesSubentities = true
                fetchRequest.includesPendingChanges = true
                
                
                let results = try self.privateManagedObjectContext.fetch(fetchRequest)
                
                DispatchQueue.main.async(execute: {
                    completionHandler(results as NSArray, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler([], SlotStoreError.cannotFetch("Cannot fetch slots days"))
                })
                
            }
        }
    }
    
    
    
    fileprivate func feed() {
    }
    
    
    
     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_: CallbackProtocol) -> Void) {
        
        
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        
        privateManagedObjectContext.perform {
            
            for singleHelper in helper {
                
                do {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Slot")
                    let predicate = NSPredicate(format: "slotId = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.fetch(fetchRequest)
                    
                    var entity:NSEntityDescription?
                    var subEntity:NSEntityDescription?
                    var coreDataObject:NSManagedObject?
                    var subCoreDataObject:NSManagedObject?
                    
                    if items.count == 0 {
                        
                        entity = NSEntityDescription.entity(forEntityName: singleHelper.entityName(), in: self.privateManagedObjectContext)
                        coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                        
                        subEntity = NSEntityDescription.entity(forEntityName: "Talk", in: self.privateManagedObjectContext)
                        subCoreDataObject = NSManagedObject(entity: subEntity!, insertInto: self.privateManagedObjectContext)
                        
                    }
                    else {
                        coreDataObject = items[0] as? Slot
                        subCoreDataObject = (coreDataObject as? Slot)?.talk
                    }
                    
                    //feed (or update)
                    
                    coreDataObject?.setValue(cfp, forKey: "cfp")
                    if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                        coreDataObjectCast.feedHelper(singleHelper)
                    }
                    
                    if let helperSlot = singleHelper as? SlotHelper  {
                        if let subCoreDataObjectFeed = subCoreDataObject as? FeedableProtocol {
                            subCoreDataObjectFeed.feedHelper(helperSlot.talk!)
                        }
                        
                        if let array = helperSlot.talk!.speakerIds {
                            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Speaker")
                            let predicate = NSPredicate(format: "href IN %@", array)
                            fetch.predicate = predicate
                            fetch.returnsObjectsAsFaults = false
                            
                            let items = try self.privateManagedObjectContext.fetch(fetch)
                            let nsm = subCoreDataObject as? Talk
                            nsm?.mutableSetValue(forKey: "speakers").removeAllObjects()
                            nsm?.mutableSetValue(forKey: "speakers").addObjects(from: items)
                        }
                    }
                    
                    coreDataObject?.setValue(subCoreDataObject as? AnyObject, forKey: "talk")
                    
                }
                    
                catch {
                    
                }
                
                
            }
            
            self.realSave(completionHandler)
        }
        
    }
    
    
    override func hasBeenAlreadyFed() -> Bool {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Slot")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            fetchRequest.predicate = predicateEvent
            let results = try self.privateManagedObjectContext.fetch(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }

    
    
    
    override func getHelper() -> DataHelperProtocol {
        return SlotHelper()
    }
    
    
}
