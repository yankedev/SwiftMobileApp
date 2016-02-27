//
//  FloorHelper.swift
//  devoxxApp
//
//  Created by maxday on 21.02.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import CoreData

class FloorHelper: DataHelperProtocol {
    
    var id: String?
    var img: String?
    var title: String?
    var tabpos: String?
    var target: String?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(img: String?, etag: String?) {
        self.id = id ?? ""
        self.img = img ?? ""
        self.title = title ?? ""
        self.tabpos = tabpos ?? ""
        self.target = target ?? ""
    }
    
    func feed(data: JSON) {
        img = data["img"].string
        title = data["title"].string
        tabpos = data["tabpos"].string
        target = data["target"].string
    }
    
    func entityName() -> String {
        return "Floor"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
    func save(managedContext : NSManagedObjectContext) -> Bool {
        
        if APIManager.exists(img!, leftPredicate:"img", entity: entityName()) {
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
