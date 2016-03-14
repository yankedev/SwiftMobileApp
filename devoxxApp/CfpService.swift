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
    
    
    static let sharedInstance = CfpService()
    

    
    override init() {
        super.init()
    }
    
    override func getHelper() -> DataHelperProtocol {
        return CfpHelper()
    }
    
    /*
    func clearAll() {
        clear("Slot")
        clear("SpeakerDetail")
        clear("Speaker")
        clear("Talk")
        clear("Track")
        clear("TalkType")
        clear("Attribute")
        clear("Etag")
        clear("Floor")
        clear("Image")
        clear("StoredResource")
        clear("Cfp")
        clear("Day")

    }
    
    func clear(entityName :  String) {
        do {
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.privateManagedObjectContext)
            fetchRequest.includesPropertyValues = false
            
            let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
            for result in results {
                self.privateManagedObjectContext.deleteObject(result as! NSManagedObject)
            }
            try realSave(nil)
        }
        catch {
            print("DONT SAVED")
        }
    }
    */
    
    func getTitle() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return cfp.title()
    }
    
    func getAdress() -> String? {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return cfp.address
    }
    
    func getCoordLat() -> Double {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return Double(cfp.latitude!)!
    }

    func getCoordLong() -> Double {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return Double(cfp.longitude!)!
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

    
    func getNbDays() -> Int {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return cfp.days.count
    }
    
    func getRegUrl() -> String? {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return cfp.regURL
    }
    
    func getDays() -> NSSet {
        let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        return cfp.days
    }
    
    func getEntryPoint() -> String {
        let cfp = self.privateManagedObjectContext.objectWithID(getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/schedules"
    }

    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            for singleHelper in helper {
            
                do {
                    
                    let fetchRequest = NSFetchRequest(entityName: "Cfp")
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
                    
                    if let cfpHelper = singleHelper as? CfpHelper {
               
                        FloorService.sharedInstance.updateWithHelper(cfpHelper.fedFloorsArray, completionHandler: self.floorsOk)
                    }
                    
                }
                catch {
                    
                }

            }
            
            self.realSave(completionHandler)
           
            
        }
        
    }
    
    func floorsOk(msg : String) {
        
    }

    
    var cfp:NSManagedObjectID? = nil
    
    func getCfp() -> NSManagedObjectID {
        
        if cfp != nil {
            //print("NOT NIL")
            return cfp!
        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Cfp")
            let predicate = NSPredicate(format: "id = %@", getCfpId())
            fetchRequest.predicate = predicate
            let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Cfp]
            if items.count > 0 {
                cfp = items[0].objectID
                return cfp!
            }
        }
        catch {
            //TODO
            cfp = nil
        }
        
        return cfp!
    }

   
    
    
    

        
}