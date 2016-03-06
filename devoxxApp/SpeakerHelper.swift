//
//  SpeakerHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class SpeakerHelper: DataHelperProtocol {
    
    var uuid: String?
    var lastName: String?
    var firstName: String?
    var avatarUrl: String?
    var href: String?


    func feed(data: JSON) {
        uuid = data["uuid"].string
        lastName = data["lastName"].string
        firstName = data["firstName"].string
        avatarUrl = data["avatarURL"].string
        href = data["links"][0]["href"].string
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    func entityName() -> String {
        return "Speaker"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json.array
    }
    
    func save(managedContext : NSManagedObjectContext) -> Bool {
        
        if APIManager.exists(uuid!, leftPredicate:"uuid", entity: entityName()) {
            return false
        }
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            
        }
        
        let entity2 = NSEntityDescription.entityForName("SpeakerDetail", inManagedObjectContext: managedContext)
        let coreDataObject2 = SpeakerDetail(entity: entity2!, insertIntoManagedObjectContext: managedContext)
        coreDataObject2.bio = "super"
    
        coreDataObject2.speaker = coreDataObject as! Speaker
        coreDataObject2.uuid = coreDataObject2.speaker.uuid!
        
        //let testBundle = NSBundle.mainBundle()

        
        
        
        
        
        
        //APIManager.innerFeed(testBundle, url: uuid!, helper: SpeakerDetailHelper())
        
        
        /*
        
        let fetch = NSFetchRequest(entityName: "SpeakerDetail")
        let predicate = NSPredicate(format: "uuid = %@", uuid!)
        fetch.predicate = predicate
        fetch.returnsObjectsAsFaults = false
        
        do {
            let items = try managedContext.executeFetchRequest(fetch)
            if items.count > 0 {
                coreDataObject.setValue(items[0], forKey: "speakerDetail")
            }
            
            
            
        } catch let error as NSError {
            print("unresolved error \(error), \(error.userInfo)")
        }
        */
        
        
        
        return true
    }
    
    
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
    /*func save(dataHelper : DataHelper) -> Void {
        super.save(dataHelper)
    }
    */
}