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
    

    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
                
                let entity = NSEntityDescription.entityForName(helper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)

                if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                    coreDataObjectCast.feedHelper(helper)
                }
                
                super.realSave(completionHandler)
                
                
            }
            catch {
                print("not found")
            }
            
            
            
        }
        
    }
    
    
}