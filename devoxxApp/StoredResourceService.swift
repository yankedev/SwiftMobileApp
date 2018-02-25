//
//  StoredResourceService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum StoredResourceStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: StoredResourceStoreError, rhs: StoredResourceStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
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
   
    func findByUrl(_ url : String) -> StoredResource {
    
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredResource")
                let predicateEvent = NSPredicate(format: "url = %@", url)
                fetchRequest.returnsDistinctResults = true
                fetchRequest.predicate = predicateEvent
                
                let items = try self.privateManagedObjectContext.fetch(fetchRequest) as! [StoredResource]
                
                if items.count > 0 {
                    return items[0]
                }
                
                let entity = NSEntityDescription.entity(forEntityName: "StoredResource", in: self.privateManagedObjectContext)
                let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                coreDataObject.setValue(url, forKey: "url")
                
                return coreDataObject as! StoredResource

            }
            catch {
                
                let entity = NSEntityDescription.entity(forEntityName: "StoredResource", in: self.privateManagedObjectContext)
                let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                coreDataObject.setValue(url, forKey: "url")
                
                return coreDataObject as! StoredResource
                
            }
        

    }

     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
        privateManagedObjectContext.perform {
            
            for singleHelper in helper {
               
                let entity = NSEntityDescription.entity(forEntityName: singleHelper.entityName(), in: self.privateManagedObjectContext)
                let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                    
                if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                    coreDataObjectCast.feedHelper(singleHelper)
                }

            }
            
            self.realSave(completionHandler)
            

        }
        
    }
    
    
}
