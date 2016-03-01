//
//  StoredResourceHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-01.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class StoredResourceHelper: DataHelperProtocol {
    
    var url: String?
    var etag: String?
    var fallback: String?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(img: String?, etag: String?) {
        self.url = url ?? ""
        self.etag = etag ?? ""
        self.fallback = fallback ?? ""
    }
    
    func feed(data: JSON) {
        url = data["url"].string
        etag = data["etag"].string
        fallback = data["fallback"].string
    }
    
    func entityName() -> String {
        return "StoredResource"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
    func save(managedContext : NSManagedObjectContext) -> Bool {
        
        if APIManager.exists(url!, leftPredicate:"url", entity: entityName()) {
            return false
        }
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            
            
            
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
