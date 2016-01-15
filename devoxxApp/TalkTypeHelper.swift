//
//  TalkTypeHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData




class TalkTypeHelper: AttributeHelper, DataHelperProtocol {
    
    
    func feed(data: JSON) {
        
        

        
        super.label = data["label"].string
        super.id = data["id"].string
        super.attributeDescription = data["description"].string
        super.type = "TalkType"
    }
    
    func entityName() -> String {
        return "Attribute"
    }
    
    func typeName() -> String {
        return "TalkType"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json["proposalTypes"].array
    }
    
  
    
    func save(managedContext : NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            if(coreDataObjectCast.exists(super.id!, leftPredicate:"id", entity: entityName())) {
                return
            }
        }
        
        
        //print("saving a talktype")
        APIManager.save(managedContext)
        
    }
    
  
    
    required override init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}