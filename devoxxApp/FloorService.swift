//
//  ImageService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum FloorStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: FloorStoreError, rhs: FloorStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}

class FloorService : AbstractService, ImageServiceProtocol {
    
    static let sharedInstance = FloorService()
    
    override init() {
        super.init()
    }
    
     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
        privateManagedObjectContext.perform {
            
            for singleHelper in helper {
                
                do {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Floor")
                    let predicate = NSPredicate(format: "id = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.fetch(fetchRequest)
                    
                    if items.count == 0 {
                        
                        let entity = NSEntityDescription.entity(forEntityName: singleHelper.entityName(), in: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                        
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

    
    func fetchFloors(_ completionHandler: @escaping (_ floors: [Floor], _ error: FloorStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
                let predicateEvent = NSPredicate(format: "id = %@", cfp.id!)
                let predicateDevice = NSPredicate(format: "target = %@", APIManager.getStringDevice())
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Floor")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateEvent, predicateDevice])
                let tabpos = NSSortDescriptor(key: "tabpos", ascending: true)
                fetchRequest.sortDescriptors = [tabpos]
                
                
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [Floor]
                
                DispatchQueue.main.async(execute: {
                    completionHandler(results, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler([], FloorStoreError.cannotFetch("Cannot fetch floors"))
                })
                
            }
        }
    }

   
    
    func updateImageForId(_ id : NSManagedObjectID, withData data: Data, completionHandler : ((_ msg: CallbackProtocol) -> Void)?) {
        
        privateManagedObjectContext.perform {
            
            if let obj:ImageFeedable = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
                obj.feedImageData(data)
            }
            
        }
        
        self.realSave(completionHandler, img : data)
        
    }
    
        
        
}
