//
//  CfpHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class CfpHelper: DataHelperProtocol {
    
    
    var id: String?
    var confType: String?
    var confDescription: String?
    var venue: String?
    var address: String?
    var country: String?
    var capacity: String?
    var sessions: String?
    var splashImgURL: String?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(id: String?, confType: String?, confDescription: String?, venue: String?, address: String?, country: String?, capacity: String?, sessions: String?, splashImgURL: String?) {
        self.id = id ?? ""
        self.confType = confType ?? ""
        self.confDescription = confDescription ?? ""
        self.venue = venue ?? ""
        self.address = address ?? ""
        self.country = country ?? ""
        self.capacity = capacity ?? ""
        self.sessions = sessions ?? ""
        self.splashImgURL = splashImgURL ?? ""
    }
    
    func feed(data: JSON) {
        id = data["id"].string
        confType = data["confType"].string
        confDescription = data["confDescription"].string
        venue = data["venue"].string
        address = data["address"].string
        country = data["country"].string
        capacity = data["capacity"].string
        sessions = data["sessions"].string
        splashImgURL = data["splashImgURL"].string
    }
    
    func entityName() -> String {
        return "Cfp"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
    
    func save(managedContext : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            if(coreDataObjectCast.exists(id!, leftPredicate:"id", entity: entityName())) {
                return
            }
        }
        
        APIManager.save(managedContext)
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}