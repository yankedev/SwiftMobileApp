//
//  CfpService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum CfpStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: CfpStoreError, rhs: CfpStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class CfpService : AbstractService {
    
    override init() {
        super.init()
    }
    
    override func getHelper() -> DataHelperProtocol {
        return CfpHelper()
    }
    
    
    
    
    func fetchCfps(completionHandler: (cfps: [Cfp], error: CfpStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                
                let fetchRequest = NSFetchRequest(entityName: "Cfp")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                
                
                let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Cfp]
                
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(cfps: results, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(cfps: [], error: CfpStoreError.CannotFetch("Cannot fetch cfps"))
                })
                
            }
        }
    }

    
    
    
    
    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
          
            let fetchRequest = NSFetchRequest(entityName: "Cfp")
            let predicate = NSPredicate(format: "id = %@", helper.getMainId())
            fetchRequest.predicate = predicate
            let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                
                if items.count == 0 {
                    print("create")
                    let entity = NSEntityDescription.entityForName(helper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                    let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)

                    if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                        coreDataObjectCast.feedHelper(helper)
                        self.realSave(completionHandler)
                    }
                    
                    
                }
                else {
                    print("already in")
                    completionHandler(msg: "OK")
                }
            
            
            }
            catch {
                print("not found")
            }
            
           
            
        }
        
    }

        
}