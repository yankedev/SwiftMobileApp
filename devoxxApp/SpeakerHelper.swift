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
    
    func save(managedContext : NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
        }
        
    
        //print("saving a speaker")
        //print(coreDataObject)
        APIManager.save(managedContext)

        
        
    }
    
    func save2() -> NSManagedObject? {
        return nil
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