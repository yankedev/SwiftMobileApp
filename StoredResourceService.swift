//
//  StoredResourceService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum StoredResourceStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: StoredResourceStoreError, rhs: StoredResourceStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class StoredResourceService : AbstractService {
    
    
    static let sharedInstance = StoredResourceService()
    
    override init() {
        super.init()
    }
    
    override func getHelper() -> DataHelperProtocol {
        return StoredResourceHelper()
    }
   
    func findByUrl(url : String) -> StoredResource {
    
            do {
                let fetchRequest = NSFetchRequest(entityName: "StoredResource")
                let predicateEvent = NSPredicate(format: "url = %@", url)
                fetchRequest.returnsDistinctResults = true
                fetchRequest.predicate = predicateEvent
                
                let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [StoredResource]
                
                if items.count > 0 {
                    return items[0]
                }
                
                let entity = NSEntityDescription.entityForName("StoredResource", inManagedObjectContext: self.privateManagedObjectContext)
                let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                coreDataObject.setValue(url, forKey: "url")
                
                return coreDataObject as! StoredResource

            }
            catch {
                
                let entity = NSEntityDescription.entityForName("StoredResource", inManagedObjectContext: self.privateManagedObjectContext)
                let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                coreDataObject.setValue(url, forKey: "url")
                
                return coreDataObject as! StoredResource
                
            }
        

    }

    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
                do {
                    
                    let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                    let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                    
                    if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                        coreDataObjectCast.feedHelper(singleHelper)
                    }

                    
                }
                catch {
                    print("not found")
                }

            }
            
            self.realSave(completionHandler)
            
            
        }
        
    }
    
    
}