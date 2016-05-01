//
//  CfpService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit
import UIKit

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
        return FloorHelper()
        //return CfpHelper()
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
        return ""
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.title()
    }
    
    func getFileTalkUrl() -> String {
        return ""
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/fileTalks"
    }
    
    func getTalkURL() -> String {
        return ""
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.talkURL ?? ""
    }
    
    func getHashtag() -> String {
        return ""
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.hashtag!
    }
    
    func getAdress() -> String? {
        return ""
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.address
    }
    
    func getVotingImage() -> String {
        return ""
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.getVotingImage()
    }
    
    func getCoordLat() -> Double {
        return 0
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return Double(cfp.latitude!)!
    }

    func getCoordLong() -> Double {
        return 0
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return Double(cfp.longitude!)!
    }
    
    func getIntegrationId() -> String {
        return "OK"
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.integration_id ?? ""
    }
    
    func fetchCfps() -> Promise<[Cfp]> {
        return Promise{ fulfill, reject in
            privateManagedObjectContext.performBlock {
                do {
                    let fetchRequest = NSFetchRequest(entityName: "Cfp")
                    fetchRequest.includesSubentities = true
                    fetchRequest.returnsObjectsAsFaults = false
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                    let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [Cfp]
                    fulfill(results)
                } catch {
                    reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                }
            }
        }
    }

    
    func getNbDays() -> Int {
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.days.count
        return 3
    }
    
    func getRegUrl() -> String? {
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.regURL
        return nil
    }
    
    func getCreditUrl() -> String {
        return "https://www.devoxx.be/credits"
    }
    
    func getDays() -> NSOrderedSet {
        //let cfp = self.privateManagedObjectContext.objectWithID(CfpService.sharedInstance.getCfp()) as! Cfp
        //return cfp.days
        return NSOrderedSet()
    }
    
    func getEntryPoint() -> String {
        //let cfp = self.privateManagedObjectContext.objectWithID(getCfp()) as! Cfp
        //return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/schedules"
        return ""
    }
    
    func getDayUrl(index : Int) -> String? {
        /*let cfp = self.privateManagedObjectContext.objectWithID(getCfp()) as? Cfp
        let day = cfp?.days.objectAtIndex(index) as? Day
        return day?.url
    */
        return ""
    }

    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        
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
                    else {
                        if let feedable = items[0] as? FeedableProtocol {
                            feedable.feedHelper(singleHelper)
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
    
    func floorsOk(msg : CallbackProtocol) {
        //todo
    }

    
   
    
    
    
    
    ///////
    func updateWithHelper(helper : [CfpHelper]) -> Promise<[Cfp]> {
        
        return Promise{ fulfill, reject in
            
            privateManagedObjectContext.performBlock {
            
                for singleHelper in helper {
                
                    do {
                    
                        let fetchRequest = NSFetchRequest(entityName: "Cfp")
                        let predicate = NSPredicate(format: "id = %@", singleHelper.getMainId())
                        fetchRequest.predicate = predicate
                        let items = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest)
                    
                    
                        for singleItem in items {
                            self.privateManagedObjectContext.deleteObject(singleItem as! NSManagedObject)
                        }

                    
                        let entity = NSEntityDescription.entityForName(singleHelper.entityName(), inManagedObjectContext: self.privateManagedObjectContext)
                        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.privateManagedObjectContext)
                        
                        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
                            coreDataObjectCast.feedHelper(singleHelper)
                        }
  
                    }
                    catch {
                        reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                    }
                 
                }
                do {
                    try self.privateManagedObjectContext.save()
                    
                    self.fetchCfps()
                    .then { (cfps: [Cfp]) -> Void in
                        fulfill(cfps)
                    }
                }
                catch {
                    reject(NSError(domain: "myDevoxx", code: 0, userInfo: nil))
                }
    
            }
        }
        
    }
    
    
    

    
    

    
}