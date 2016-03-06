//
//  DayHelper.swift
//  devoxxApp
//
//  Created by maxday on 02.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DayHelper: DataHelperProtocol {
    
    var url: String?
    var cfp : Cfp?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(cfp : Cfp?, url: String?) {
        self.url = url ?? ""
        self.cfp = cfp
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!

        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: context)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            cfp = APIManager.currentEvent
            cfp = APIManager.findOne("id", value: (cfp?.id)!, entity: "Cfp", context: context) as! Cfp
            coreDataObjectCast.feedHelper(self)
        }
        
        APIManager.save(context)
       
        
        return true
        
        //APIManager.save(managedContext)
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}
