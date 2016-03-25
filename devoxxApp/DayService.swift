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
    
  
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
   
            let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
            
            for singleHelper in helper {
                do {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Day")
                    
                    //print("main id = \(singleHelper.getMainId())")
                    let predicate = NSPredicate(format: "url = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    if items.count == 0 {
                        
                        
                        
                        let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                            
                            
                            
                            coreDataObject.setValue(cfp, forKey: "cfp")
                            
                            
                        }
                        
                        
                        
                       
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                catch {
                    //print("not found")
                }
            }
            
             self.realSave(completionHandler)
            
        }
        
    }
    
    override func getHelper() -> DataHelperProtocol {
        return DayHelper()
    }
    
    
    override func hasBeenAlreadyFed() -> Bool {
        do {
            let fetchRequest = NSFetchRequest(entityName: "Day")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            fetchRequest.predicate = predicateEvent
            let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }

    
   

    
   


    
    
}