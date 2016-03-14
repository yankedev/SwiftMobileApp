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
    
    
    static let sharedInstance = AttributeService()
    
    
    
    func fetchFilters(completionHandler: (filters: NSFetchedResultsController?, error: AttributeStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
        
                let fetchRequest = NSFetchRequest(entityName: "Attribute")
                let sortSection = NSSortDescriptor(key: "type", ascending: true)
                let sortAlpha = NSSortDescriptor(key: "label", ascending: true)
                
                let predicateEvent = NSPredicate(format: "cfp.id = %@", CfpService.sharedInstance.getCfpId())
                
                fetchRequest.sortDescriptors = [sortSection, sortAlpha]
                fetchRequest.fetchBatchSize = 20
                
                fetchRequest.predicate = predicateEvent
                
                let frc = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: self.privateManagedObjectContext,
                    sectionNameKeyPath: "type",
                    cacheName: nil)
                
                try frc.performFetch()
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(filters: frc, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(filters: nil, error: AttributeStoreError.CannotFetch("Cannot fetch attributes"))
                })
                
            }
        }
    }

    
    func fetchTracks(completionHandler: (attributes: [Attribute], error: AttributeStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                
                let predicateEvent = NSPredicate(format: "cfp.id = %@", self.getCfpId())
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
    
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                do {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Attribute")
                    let predicate = NSPredicate(format: "id = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if items.count == 0 {
                        
                        
                        let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                            
                            coreDataObject.setValue(cfp, forKey: "cfp")
                            
                        }
 
                    }
                    else {
              
                    }
                    
                    
                }
                catch {
                    print("not found")
                }

            }
            
            self.realSave(completionHandler)
            
        }
        
    }

    
    func getTracksUrl() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/tracks"
    }
    
    func getTalkTypeUrl() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/proposalTypes"
    }


}

