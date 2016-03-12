//
//  AttributeService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum AttributeStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: AttributeStoreError, rhs: AttributeStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}

class AttributeService : AbstractService {
    
    override init() {
        super.init()
    }
    
    
    func fetchTracks(completionHandler: (attributes: [Attribute], error: AttributeStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                let currentCfp:Cfp? = APIDataManager.findEntityFromId(APIManager.currentEvent.objectID, inContext: self.privateManagedObjectContext)

                let predicateEvent = NSPredicate(format: "cfp = %@", currentCfp!)
                let fetchRequest = NSFetchRequest(entityName: "Attribute")
                let predicateType = NSPredicate(format: "type = %@", "Track")
                fetchRequest.returnsDistinctResults = true
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
                
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateType])
                
                let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Attribute]
                
                //let's check that this track contains at least one talk, otherwise we should not return it
                var res = [Attribute]()

                for it in items  {
                    
                    let fetchRequestSlot = NSFetchRequest(entityName: "Slot")
                    fetchRequestSlot.fetchBatchSize = 20
                    fetchRequestSlot.returnsObjectsAsFaults = false
                    
                    let predicateTrack = NSPredicate(format: "talk.track = %@", it.label!)
                    fetchRequestSlot.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateTrack])
                    let itemsRes = try self.privateManagedObjectContext.executeFetchRequest(fetchRequestSlot)
  
                    if itemsRes.count > 0 {
                        res.append(it)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(attributes: res, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(attributes: [], error: AttributeStoreError.CannotFetch("Cannot fetch attributes"))
                })
                
            }
        }
    }

}

