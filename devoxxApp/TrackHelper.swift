//
//  TrackHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class TrackHelper: AttributeHelper, DataHelperProtocol {
  

    func feed(data: JSON) {
    
        
        super.label = data["title"].string
        super.id = data["id"].string
        super.attributeDescription = data["trackDescription"].string
        
        super.type = "Track"
    }

    func entityName() -> String {
        return "Attribute"
    }
    
    func typeName() -> String {
        return "Track"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json["tracks"].array
    }
    
    func save(managedContext : NSManagedObjectContext) {
      
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
        }
                
        
        
        //print("saving a track")
        APIManager.save(managedContext)
        
    }
    
    func save2() -> NSManagedObject? {
        return nil
    }
    
    required override init() {
    }
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
    func filterPredicate() -> String {
        return "talk.trackId"
    }
    
   
    
}
