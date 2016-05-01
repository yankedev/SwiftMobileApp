//
//  SlotHelper.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit
import Unbox


public enum SlotStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: SlotStoreError, rhs: SlotStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class SlotService : AbstractService {
    
    static let sharedInstance = SlotService()
    
    override init() {
        super.init()
    }
    
    
    
    
    func fetchCfpDay(completionHandler: (slots: NSArray, error: SlotStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                let fetchRequest = NSFetchRequest(entityName: "Slot")
                let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
                fetchRequest.resultType = .DictionaryResultType
                fetchRequest.returnsDistinctResults = true
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                fetchRequest.propertiesToFetch = ["date"]
                fetchRequest.predicate = predicateEvent
                
                let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(slots: results, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(slots: [], error: SlotStoreError.CannotFetch("Cannot fetch slots days"))
                })
                
            }
        }
    }
    
    
    
    private func feed() {
    }
    
    
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        
        
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                
                do {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Slot")
                    let predicate = NSPredicate(format: "slotId = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    var entity:NSEntityDescription?
                    var subEntity:NSEntityDescription?
                    var coreDataObject:NSManagedObject?
                    var subCoreDataObject:NSManagedObject?
                    
                    if items.count == 0 {
                        
                        entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        subEntity = NSEntityDescription.entityForName("Talk", inManagedObjectContext: self.privateManagedObjectContext)
                        subCoreDataObject = NSManagedObject(entity: subEntity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
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
                            let fetch = NSFetchRequest(entityName: "Speaker")
                            let predicate = NSPredicate(format: "href IN %@", array)
                            fetch.predicate = predicate
                            fetch.returnsObjectsAsFaults = false
                            
                            let items = try self.privateManagedObjectContext.executeFetchRequest(fetch)
                            let nsm = subCoreDataObject as? Talk
                            nsm?.mutableSetValueForKey("speakers").addObjectsFromArray(items)
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
            let fetchRequest = NSFetchRequest(entityName: "Slot")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            fetchRequest.predicate = predicateEvent
            let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }

    
    
    
    override func getHelper() -> DataHelperProtocol {
        return SlotHelper()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /////
    
    override func entryPoint() -> [String] {
        return ["http://cfp.devoxx.fr/api/conferences/DevoxxFR2016/schedules/wednesday/", "http://cfp.devoxx.fr/api/conferences/DevoxxFR2016/schedules/thursday/", "http://cfp.devoxx.fr/api/conferences/DevoxxFR2016/schedules/friday/"]
    }
    
    
    
    
    override func fetch(cfpId : NSManagedObjectID) -> Promise<[NSManagedObject]> {
        return Promise{ fulfill, reject in
            privateManagedObjectContext.performBlock {
                do {
                    
                    let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                    
                    let predicateEvent = NSPredicate(format: "cfp.id = %@", cfp.id!)
                    let fetchRequest = NSFetchRequest(entityName: "Slot")
                    fetchRequest.includesSubentities = true
                    fetchRequest.returnsObjectsAsFaults = false
                    fetchRequest.predicate = predicateEvent
                    let sortLast = NSSortDescriptor(key: "date", ascending: true)
                    fetchRequest.sortDescriptors = [sortLast]
                    
                    let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                    fulfill(results)
                } catch {
                    reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    override func unboxData(data : NSData) -> [NSManagedObject] {
        do {
            let json = JSON(data: data)
            let arrayToParse = try json["slots"].rawData()
            let arr : [Slot] = try UnboxOrThrow(arrayToParse)
            return arr
        }
        catch {
            return [Slot]()
        }
    }
    
    override func update(cfpId : NSManagedObjectID, items : [NSManagedObject]) -> Promise<[NSManagedObject]> {
        
        return Promise{ fulfill, reject in
            
            privateManagedObjectContext.performBlock {
                
                let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                
                for attribute in items {
                    guard let attributeCast = attribute as? Slot else {
                        reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                        return
                    }
                    attributeCast.cfp = cfp
                }
                do {
                    try self.privateManagedObjectContext.save()
                    fulfill(items)
                }
                catch {
                    reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                }
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}