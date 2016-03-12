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
    var talkURL: String?
    var splashImgURL: String?
    var hashtag: String?
    var fromDate: String?
    var regURL: String?
    var cfpEndpoint: String?
    
    var fedFloorsArray:Array<FloorHelper>!
    
    func typeName() -> String {
        return entityName()
    }
    
    func getMainId() -> String {
        return id!
    }

    
    init(id: String?, confType: String?, confDescription: String?, venue: String?, address: String?, country: String?, capacity: String?, sessions: String?, latitude:String?, longitude:String?, splashImgURL: String?, hashtag: String?, fromDate: String?, talkURL: String?, regURL : String?, cfpEndpoint : String?) {
        self.id = id ?? ""
        self.confType = confType ?? ""
        self.confDescription = confDescription ?? ""
        self.venue = venue ?? ""
        self.address = address ?? ""
        self.country = country ?? ""
        self.regURL = regURL ?? ""
        self.fromDate = fromDate ?? ""
        self.talkURL = talkURL ?? ""
        self.capacity = capacity ?? ""
        self.sessions = sessions ?? ""
        self.latitude = latitude ?? ""
        self.cfpEndpoint = cfpEndpoint ?? ""
        self.longitude = longitude ?? ""
        self.splashImgURL = splashImgURL ?? ""
        self.hashtag = hashtag ?? ""

    }
    
    func feed(data: JSON) {
   
        id = data["id"].string
        confType = data["confType"].string
        confDescription = data["confDescription"].string
        venue = data["venue"].string
        address = data["address"].string
        country = data["country"].string
        talkURL = data["talkURL"].string
        cfpEndpoint = data["cfpEndpoint"].string
        capacity = data["capacity"].string
        fromDate = data["fromDate"].string
        sessions = data["sessions"].string
        regURL = data["regURL"].string
        latitude = data["latitude"].string
        longitude = data["longitude"].string
        splashImgURL = data["splashImgURL"].string
        hashtag = data["hashtag"].string
   
        fedFloorsArray = Array<FloorHelper>()
        
        if let floorArray = data["floors"].array {

            for spk in floorArray {
                let floorHelper = FloorHelper()
                floorHelper.feed(spk)
                floorHelper.id = id
                fedFloorsArray.append(floorHelper)
            }
            
        }

       
    }
    
    func entityName() -> String {
        return "Cfp"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
    
    func save(managedContext : NSManagedObjectContext) ->Bool {
        
        if APIManager.exists(id!, leftPredicate:"id", entity: entityName()) {
            return false
        }
        
        for floor in fedFloorsArray {
            floor.save(managedContext)
        }
        APIManager.save(managedContext)
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            coreDataObjectCast.feedHelper(self)
            
            let fetch = NSFetchRequest(entityName: "Floor")
            //let predicate = NSPredicate(format: "id = %@", self.id!)
            //fetch.predicate = predicate
            fetch.returnsObjectsAsFaults = false
            
            
            let items = getAllFloors(managedContext, withId:self.id!)

            coreDataObject.mutableSetValueForKey("floors").addObjectsFromArray(items as [AnyObject])

       
            
            
        }
        
        return true
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
    
    func getAllFloors(context : NSManagedObjectContext, withId : String) -> NSArray {
        let fetchRequest = APIManager.buildFetchRequest(context, name: "Floor")
        let predicate = NSPredicate(format: "id = %@", withId)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        return items
    }
    
}