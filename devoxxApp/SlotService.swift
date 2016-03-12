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
    
    override init() {
        super.init()
    }
    
   
    
    
    
    func fetchCfps(completionHandler: (slots: [Slot], error: SlotStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                let fetchRequest = NSFetchRequest(entityName: "Slot")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "slotId", ascending: true)]
                
                
                let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Slot]
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(slots: results, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(slots: [], error: SlotStoreError.CannotFetch("Cannot fetch slots"))
                })
                
            }
        }
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
    
    
 
    
    
    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
                
                let fetchRequest = NSFetchRequest(entityName: "Slot")
                let predicate = NSPredicate(format: "slotId = %@", helper.getMainId())
                fetchRequest.predicate = predicate
                let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                
                if items.count == 0 {
                    print("create")
                    let entity = NSEntityDescription.entityForName(helper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                    let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                    
                    if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                        coreDataObjectCast.feedHelper(helper)
                        self.realSave(completionHandler)
                    }
                    
                    
                }
                else {
                    print("already in")
                    completionHandler(msg: "OK")
                }
                
                
            }
            catch {
                print("not found")
            }
            
            
            
        }
        
    }
    
    override func getHelper() -> DataHelperProtocol {
        return SlotHelper()
    }
    
    
}