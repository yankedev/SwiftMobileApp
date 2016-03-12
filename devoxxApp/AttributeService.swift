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
    
    func fetchTracks(completionHandler: (attributes: [Attribute], error: AttributeStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                
                let predicateEvent = NSPredicate(format: "cfp = %@", self.getCfp()!)
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
    
    
    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
                
                let fetchRequest = NSFetchRequest(entityName: "Attribute")
                let predicate = NSPredicate(format: "id = %@", helper.getMainId())
                fetchRequest.predicate = predicate
                let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                
                if items.count == 0 {
                    print("create")
                    
                    let entity = NSEntityDescription.entityForName(helper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                    let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                    
                    if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                        coreDataObjectCast.feedHelper(helper)
                        
                        coreDataObject.setValue(super.getCfp(), forKey: "cfp")
                        self.realSave(completionHandler)
                    }

                    
                
                    
                    
                }
                else {
                    //print("already in")
                    completionHandler(msg: "OK")
                }
                
                
            }
            catch {
                print("not found")
            }
            
            
            
        }
        
    }

    
    func getTracksUrl() -> String {
        let cfp = super.getCfp()
        return "\(cfp!.cfpEndpoint!)/conferences/\(cfp!.id!)/tracks"
    }
    
    func getTalkTypeUrl() -> String {
        let cfp = super.getCfp()
        return "\(cfp!.cfpEndpoint!)/conferences/\(cfp!.id!)/proposalTypes"
    }
    
    override func getHelper() -> DataHelperProtocol {
        return TrackHelper()
    }

}

