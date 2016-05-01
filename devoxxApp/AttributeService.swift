//
//  AttributeService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit
import Unbox

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
    
    
    override func update(cfpId : NSManagedObjectID, items : [NSManagedObject]) -> Promise<[NSManagedObject]> {
        
        return Promise{ fulfill, reject in
            
            privateManagedObjectContext.performBlock {
                
                let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                
                for attribute in items {
                    guard let attributeCast = attribute as? Attribute else {
                        reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                        return
                    }
                    attributeCast.setValue(cfp, forKey: "cfp")
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

    
    
    func getTracksUrl() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/tracks"
    }
    
    func getTalkTypeUrl() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/proposalTypes"
    }
    
    
    
    
    override func entryPoint() -> String {
        return "http://cfp.devoxx.fr/api/conferences/DevoxxFR2016/tracks"
    }
    
    
    
    
    override func fetch(cfpId : NSManagedObjectID) -> Promise<[NSManagedObject]> {
        return Promise{ fulfill, reject in
            privateManagedObjectContext.performBlock {
                do {
                    
                    let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                    
                    let predicateEvent = NSPredicate(format: "cfp.id = %@", cfp.id!)
                    let fetchRequest = NSFetchRequest(entityName: "Attribute")
                    fetchRequest.includesSubentities = true
                    fetchRequest.returnsObjectsAsFaults = false
                    fetchRequest.predicate = predicateEvent
                    let sortLast = NSSortDescriptor(key: "label", ascending: true)
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
            let arrayToParse = try json["tracks"].rawData()
            let arr : [Attribute] = try UnboxOrThrow(arrayToParse)
            return arr
        }
        catch {
            return [Attribute]()
        }
    }

}

