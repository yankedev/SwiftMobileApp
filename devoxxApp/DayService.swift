//
//  DayService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum DayStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: DayStoreError, rhs: DayStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class DayService : AbstractService {
    
    static let sharedInstance = DayService()
    
    override init() {
        super.init()
    }
    
  
    
     override func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
        privateManagedObjectContext.perform {
            
   
            let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
            
            for singleHelper in helper {
                do {
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
                    
                    //print("main id = \(singleHelper.getMainId())")
                    let predicate = NSPredicate(format: "url = %@", singleHelper.getMainId())
                    fetchRequest.predicate = predicate
                    let items = try self.privateManagedObjectContext.fetch(fetchRequest)
                    
                    if items.count == 0 {
                        
                        
                        
                        let entity = NSEntityDescription.entity(forEntityName: singleHelper.entityName(), in: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertInto: self.privateManagedObjectContext)
                        
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
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
            let predicateEvent = NSPredicate(format: "cfp.id = %@", super.getCfpId())
            fetchRequest.predicate = predicateEvent
            let results = try self.privateManagedObjectContext.fetch(fetchRequest)
            return results.count > 0
        }
        catch {
            return false
        }
    }

    
   

    
   


    
    
}
