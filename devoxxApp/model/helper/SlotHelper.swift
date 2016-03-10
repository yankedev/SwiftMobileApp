//
//  SlotHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class SlotHelper: DataHelperProtocol {
    
    var roomName: String?
    var slotId: String?
    var fromTime: String?
    var toTime: String?
    var day: String?
    var fromTimeMillis : NSNumber?
    var talk : TalkHelper?
    
    
    func typeName() -> String {
        return entityName()
    }
     func description() -> String {
        return "roomName: \(roomName)\n slotId: \(slotId)\n fromTime: \(fromTime) \n talk: \(talk)\n day: \(day)\n"
    }
    

    init(roomName: String?, slotId: String?, fromTime: String?, toTime:String?, day: String?, talk: TalkHelper) {
        self.roomName = roomName ?? ""
        self.slotId = slotId ?? ""
        self.fromTime = fromTime ?? ""
        self.toTime = toTime ?? ""
        self.day = day ?? ""
        self.talk = talk
    }
    
    func feed(data: JSON) {
    
        roomName = data["roomName"].string
        slotId = data["slotId"].string
        fromTime = data["fromTime"].string
        toTime = data["toTime"].string
        day = data["day"].string
        fromTimeMillis = data["fromTimeMillis"].doubleValue
   
        let talkHelper = TalkHelper()
        
        let subData = talkHelper.prepareArray(data)
        
        
        talkHelper.feed(subData![0])
        talk = talkHelper
    }
    
   
    
    
    func entityName() -> String {
        return "Slot"
    }
    
    func fileName() -> String {
        return entityName()
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json["slots"].array
    }
    
   
    
    func generateFavorite(managedContext:NSManagedObjectContext, identifier: String, type: String) {
        let favEntity = NSEntityDescription.entityForName("Favorite", inManagedObjectContext: managedContext)
        let favCoreData = Favorite(entity: favEntity!, insertIntoManagedObjectContext: managedContext)
        favCoreData.id = identifier
        favCoreData.isFavorited = 0
        favCoreData.type = type
    }
    
    func save(managedContext : NSManagedObjectContext) -> Bool {
        
        if APIManager.exists(slotId!, leftPredicate:"slotId", entity: entityName()) {
            return false
        }

        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
 
            coreDataObjectCast.feedHelper(self)
            
            
            
            let currentCfp:Cfp? = APIDataManager.findEntityFromId(APIManager.currentEvent.objectID, inContext: managedContext)
            
            coreDataObject.setValue(currentCfp, forKey: "cfp")
            
            
            
            
            let subEntity = NSEntityDescription.entityForName("Talk", inManagedObjectContext: managedContext)
            let subDataObject = NSManagedObject(entity: subEntity!, insertIntoManagedObjectContext: managedContext) as! FeedableProtocol
            
            subDataObject.feedHelper(self.talk!)
            
            
            coreDataObject.setValue(subDataObject as? AnyObject, forKey: "talk")
            
            
            
            
            let fetch = NSFetchRequest(entityName: "Speaker")
            let predicate = NSPredicate(format: "href IN %@", self.talk!.speakerIds)
            fetch.predicate = predicate
            fetch.returnsObjectsAsFaults = false
            //fetch.resultType = .ManagedObjectResultType
            
            
            
            do {
                let items = try managedContext.executeFetchRequest(fetch)
                let nsm = subDataObject as! Talk
                nsm.mutableSetValueForKey("speakers").addObjectsFromArray(items)
                
                //iterate over speaker and set talk
                
                
            } catch let error as NSError {
                //print("unresolved error \(error), \(error.userInfo)")
            }

            
            
            
            
            
            /*for att in (entity?.properties)! {
            
                if let relation = att as? NSRelationshipDescription  {
                    let relationName = relation.name
                    let subEntity = NSEntityDescription.entityForName(relationName.capitalizedString, inManagedObjectContext: managedContext)
                    let subDataObject = NSManagedObject(entity: subEntity!, insertIntoManagedObjectContext: managedContext) as! FeedableProtocol
                    
                    subDataObject.feedHelper(self.talk!)

                              
                    let fetch = NSFetchRequest(entityName: "Speaker")
                    let predicate = NSPredicate(format: "href IN %@", self.talk!.speakerIds)
                    fetch.predicate = predicate
                    fetch.returnsObjectsAsFaults = false
                    //fetch.resultType = .ManagedObjectResultType
                    
                    
                    
                    do {
                        let items = try managedContext.executeFetchRequest(fetch)
                        let nsm = subDataObject as! Talk
                        nsm.mutableSetValueForKey("speakers").addObjectsFromArray(items)
                        
                        //iterate over speaker and set talk
                        
                                               
                    } catch let error as NSError {
                        //print("unresolved error \(error), \(error.userInfo)")
                    }
                  
                    coreDataObject.setValue(subDataObject as? AnyObject, forKey: relationName)
                    
                }
                
            }*/
            
            
        }
        
        
        if let coreDataObjectCast = coreDataObject as? FavoriteProtocol {
            generateFavorite(managedContext, identifier: coreDataObjectCast.getIdentifier(), type: "Talk")
        }
        
        return true
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
    
    
}