//
//  CfpHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CfpHelper: DataHelperProtocol {
    
    
    var id: String?
    var confType: String?
    var confDescription: String?
    var venue: String?
    var address: String?
    var country: String?
    var capacity: String?
    var sessions: String?
    var latitude: String?
    var longitude: String?
    var splashImgURL: String?
    
    var fedFloorsArray:Array<FloorHelper>!
    
    func typeName() -> String {
        return entityName()
    }
    
    init(id: String?, confType: String?, confDescription: String?, venue: String?, address: String?, country: String?, capacity: String?, sessions: String?, latitude:String?, longitude:String?, splashImgURL: String?) {
        self.id = id ?? ""
        self.confType = confType ?? ""
        self.confDescription = confDescription ?? ""
        self.venue = venue ?? ""
        self.address = address ?? ""
        self.country = country ?? ""
        self.capacity = capacity ?? ""
        self.sessions = sessions ?? ""
        self.latitude = latitude ?? ""
        self.longitude = longitude ?? ""
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
        latitude = data["latitude"].string
        longitude = data["longitude"].string
        splashImgURL = data["splashImgURL"].string
   
        fedFloorsArray = Array<FloorHelper>()
        
        if let floorArray = data["floors"].array {

            for spk in floorArray {
                let floorHelper = FloorHelper()
                floorHelper.feed(spk)
                floorHelper.id = id
                fedFloorsArray.append(floorHelper)
            }
            
        }

        
        //floors = data["floors"].array?.description
    }
    
    func entityName() -> String {
        return "Cfp"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
    
    func save(managedContext : NSManagedObjectContext) {
        
        for floor in fedFloorsArray {
            floor.save(managedContext)
        }
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            
            let fetch = NSFetchRequest(entityName: "Floor")
            //let predicate = NSPredicate(format: "id = %@", self.id!)
            //fetch.predicate = predicate
            fetch.returnsObjectsAsFaults = false
            
            
            
            let items = APIManager.debugAllFloors(managedContext, withId:self.id!)

            coreDataObject.mutableSetValueForKey("floors").addObjectsFromArray(items as [AnyObject])

          
            
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