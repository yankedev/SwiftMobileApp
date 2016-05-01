//
//  TrackService.swift
//  My_Devoxx
//
//  Created by Maxime on 13/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit
import Unbox

class TrackService : AbstractService {
    
    static let sharedInstance = TrackService()
    
    override func getHelper() -> DataHelperProtocol {
        return TrackHelper()
    }
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        AttributeService.sharedInstance.updateWithHelper(helper, completionHandler: completionHandler)
    }
    
    override func hasBeenAlreadyFed() -> Bool {
        do {
            let fetchRequest = NSFetchRequest(entityName: "Attribute")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            let predicateType = NSPredicate(format: "type = %@", "Track")
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateType])
            let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }
    
    
    override func entryPoint() -> [String] {
        return ["http://cfp.devoxx.fr/api/conferences/DevoxxFR2016/tracks"]
    }
    
    override func fetch(cfpId : NSManagedObjectID) -> Promise<[NSManagedObject]> {
        return Promise{ fulfill, reject in
            privateManagedObjectContext.performBlock {
                do {
                    
                    let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                    
                    let predicateEvent = NSPredicate(format: "cfp.id = %@", cfp.id!)
                    let predicateAttribute = NSPredicate(format: "label = %@", "track")
                    let fetchRequest = NSFetchRequest(entityName: "Attribute")
                    fetchRequest.includesSubentities = true
                    fetchRequest.returnsObjectsAsFaults = false
                    fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateAttribute])
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
    
    override func update(cfpId : NSManagedObjectID, items : [NSManagedObject]) -> Promise<[NSManagedObject]> {
        
        return Promise{ fulfill, reject in
            
            privateManagedObjectContext.performBlock {
                
                let cfp = self.privateManagedObjectContext.objectWithID(cfpId) as! Cfp
                
                for attribute in items {
                    guard let attributeCast = attribute as? Attribute else {
                        reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                        return
                    }
                    attributeCast.cfp = cfp
                    attributeCast.label = "track"
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
