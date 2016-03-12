//
//  DayService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum DayStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: DayStoreError, rhs: DayStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class DayService : AbstractService {
    
    static let sharedInstance = DayService()
    
    override init() {
        super.init()
    }
    
  
    
    override func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
                
                let fetchRequest = NSFetchRequest(entityName: "Day")
                let predicate = NSPredicate(format: "url = %@", helper.getMainId())
                fetchRequest.predicate = predicate
                let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                
                if items.count == 0 {
                   
                    
                    
                    let entity = NSEntityDescription.entityForName(helper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                    let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                    
                    if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                        coreDataObjectCast.feedHelper(helper)
                        coreDataObject.setValue(super.getCfp(), forKey: "cfp")
                    }
                    
                    
                    self.realSave(completionHandler)
                 
                    
                    
                }
                else {
                    //print("CALL COMPLETION HANDLER 1")
                    completionHandler(msg: "OK")
                }
                
                
            }
            catch {
                print("not found")
            }
            
            
            
        }
        
    }
    
    override func getHelper() -> DataHelperProtocol {
        return DayHelper()
    }
    
    
}