//
//  ImageService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum FloorStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: FloorStoreError, rhs: FloorStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}

class FloorService : AbstractService, ImageServiceProtocol {
    
    static let sharedInstance = FloorService()
    
    override init() {
        super.init()
    }
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                
                do {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Floor")
                    let predicate = NSPredicate(format: "id = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if items.count == 0 {
                        
                        let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
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

    
    func fetchFloors(completionHandler: (floors: [Floor], error: FloorStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
                let predicateEvent = NSPredicate(format: "id = %@", cfp.id!)
                let predicateDevice = NSPredicate(format: "target = %@", APIManager.getStringDevice())
                let fetchRequest = NSFetchRequest(entityName: "Floor")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateDevice])
                let tabpos = NSSortDescriptor(key: "tabpos", ascending: true)
                fetchRequest.sortDescriptors = [tabpos]
                
                
                let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Floor]
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(floors: results, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(floors: [], error: FloorStoreError.CannotFetch("Cannot fetch floors"))
                })
                
            }
        }
    }

   
    
    func updateImageForId(id : NSManagedObjectID, withData data: NSData, completionHandler : ((msg: CallbackProtocol) -> Void)?) {
        
        privateManagedObjectContext.performBlock {
            
            if let obj:ImageFeedable = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
                obj.feedImageData(data)
            }
            
        }
        
        self.realSave(completionHandler, img : data)
        
    }
    
        
        
}