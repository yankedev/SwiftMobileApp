//
//  SlotHelper.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


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
    
    
 
    
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                
                do {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Slot")
                    let predicate = NSPredicate(format: "slotId = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if items.count == 0 {
                        
                        let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                            
                            
                            
                            
                            coreDataObject.setValue(cfp, forKey: "cfp")
                            
                            let subEntity = NSEntityDescription.entityForName("Talk", inManagedObjectContext: self.privateManagedObjectContext)
                            let subDataObject = NSManagedObject(entity: subEntity!, insertIntoManagedObjectContext: self.privateManagedObjectContext) as! FeedableProtocol
                            
                            if let helperSlot = singleHelper as? SlotHelper {
                                subDataObject.feedHelper(helperSlot.talk!)
                                
                                if let array = helperSlot.talk!.speakerIds {
                                
                                    let fetch = NSFetchRequest(entityName: "Speaker")
                                    
                                    let predicate = NSPredicate(format: "href IN %@", array)
                                    fetch.predicate = predicate
                                    fetch.returnsObjectsAsFaults = false
                                    
                                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetch)
                                    let nsm = subDataObject as! Talk
                                    nsm.mutableSetValueForKey("speakers").addObjectsFromArray(items)
                                }
                                
                                
                                
                            }
                            
                            coreDataObject.setValue(subDataObject as? AnyObject, forKey: "talk")
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    else {
                        //print("CALL COMPLETION HANDLER 1")
                        //completionHandler(msg: "OK")
                    }
                    
                    
                }
                catch {
                    
                }

                
            }
            
            self.realSave(completionHandler)
        }
        
    }
    

    

    
    override func getHelper() -> DataHelperProtocol {
        return SlotHelper()
    }
    
    
}