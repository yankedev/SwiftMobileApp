//
//  DayHelper.swift
//  devoxxApp
//
//  Created by maxday on 02.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class DayHelper: DataHelperProtocol {
    
    var url: String?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(url: String?) {
        self.url = url ?? ""
    }
    
    func feed(data: JSON) {
        url = data["href"].string
        
    }
    
    func entityName() -> String {
        return "Day"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json["links"].array
    }
    
    
    func save(managedContext : NSManagedObjectContext) -> Bool {
        
        if APIManager.exists(url!, leftPredicate:"url", entity: entityName()) {
            return false
        }
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            
            let currentEvent = APIDataManager.findEventFromId(managedContext)
            coreDataObject.setValue(currentEvent, forKey: "cfp")

   
            
            
        }
        
       
        
        return true
        
        //APIManager.save(managedContext)
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}
