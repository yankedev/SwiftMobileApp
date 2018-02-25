//
//  AttributeService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum AttributeStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: AttributeStoreError, rhs: AttributeStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}

class AttributeService : AbstractService {
    
    override init() {
        super.init()
    }
    
    
    static let sharedInstance = AttributeService()
    
    
    
    func fetchFilters(_ completionHandler: @escaping (_ filters: NSFetchedResultsController<NSFetchRequestResult>?, _ error: AttributeStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
        
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Attribute")
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
                DispatchQueue.main.async(execute: {
                    completionHandler(frc, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler(nil, AttributeStoreError.cannotFetch("Cannot fetch attributes"))
                })
                
            }
        }
    }

    
    func fetchTracks(_ completionHandler: @escaping (_ attributes: [Attribute], _ error: AttributeStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                
                
                let predicateEvent = NSPredicate(format: "cfp.id = %@", self.getCfpId())
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Attribute")
                let predicateType = NSPredicate(format: "type = %@", "Track")
                fetchRequest.returnsDistinctResults = true
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
                
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateType])
                
                let items = try self.privateManagedObjectContext.fetch(fetchRequest) as! [Attribute]
                
                //let's check that this track contains at least one talk, otherwise we should not return it
                var res = [Attribute]()

                for it in items  {
                    
                    let fetchRequestSlot = NSFetchRequest<NSFetchRequestResult>(entityName: "Slot")
                    fetchRequestSlot.fetchBatchSize = 20
                    fetchRequestSlot.returnsObjectsAsFaults = false
                    
                    let predicateTrack = NSPredicate(format: "talk.track = %@", it.label!)
                    fetchRequestSlot.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateTrack])
                    let itemsRes = try self.privateManagedObjectContext.fetch(fetchRequestSlot)
  
                    if itemsRes.count > 0 {
                        res.append(it)
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    completionHandler(res, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler([], AttributeStoreError.cannotFetch("Cannot fetch attributes"))
                })
                
            }
        }
    }
    
    
     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        
        privateManagedObjectContext.perform {
            
            for singleHelper in helper {
                do {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Attribute")
                    let predicate = NSPredicate(format: "id = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.fetch(fetchRequest)
                    
                    if items.count == 0 {
                        
                        
                        let entity = NSEntityDescription.entity(forEntityName: singleHelper.entityName(), in: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                            
                            coreDataObject.setValue(cfp, forKey: "cfp")
                            
                        }
 
                    }
                    else {
              
                    }
                    
                    
                }
                catch {
           
                }

            }
            
            self.realSave(completionHandler)
            
        }
        
    }

    
    func getTracksUrl() -> String {
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/tracks"
    }
    
    func getTalkTypeUrl() -> String {
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/proposalTypes"
    }


}

