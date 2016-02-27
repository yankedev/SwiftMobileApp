//
//  SpeakerDetailHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-26.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class SpeakerDetailHelper: DataHelperProtocol {
    
    var uuid: String?
    var bio: String?
    var bioAsHtml: String?
    var company: String?
    var twitter: String?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(uuid: String?, bio: String?, bioAsHtml: String?, company: String?, twitter: String?) {
        self.uuid = uuid ?? ""
        self.bio = bio ?? ""
        self.bioAsHtml = bioAsHtml ?? ""
        self.company = company ?? ""
        self.twitter = twitter ?? ""
    }
    
    func feed(data: JSON) {
        uuid = data["uuid"].string
        bio = data["bio"].string
        bioAsHtml = data["bioAsHtml"].string
        company = data["company"].string
        twitter = data["twitter"].string
    }
    
    func entityName() -> String {
        return "SpeakerDetail"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        
       
        
        var array = [JSON]()
        array.append(json)
        return array
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
        
        return true
        
   
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}
