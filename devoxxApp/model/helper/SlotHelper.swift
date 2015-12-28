//
//  SlotHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class SlotHelper: DataHelper {
    let roomName: String
    let slotId: String
    let fromTime: String
    let day: String
    let talk : TalkHelper
    
    override var description: String {
        return "roomName: \(roomName)\n slotId: \(slotId)\n fromTime: \(fromTime) \n talk: \(talk)\n day: \(day)\n"
    }
    
    init(roomName: String?, slotId: String?, fromTime: String?, day: String?, talk: TalkHelper) {
        self.roomName = roomName ?? ""
        self.slotId = slotId ?? ""
        self.fromTime = fromTime ?? ""
        self.day = day ?? ""
        self.talk = talk
    }
    
    override class func feed(data: JSON) -> SlotHelper? {
        
        let roomName: String? = data["roomName"].string
        let slotId: String? = data["slotId"].string
        let fromTime: String? = data["fromTime"].string
        let day: String? = data["day"].string
        
        let talk = TalkHelper.feed(data["talk"])
        
        let sl =  SlotHelper(roomName: roomName, slotId: slotId, fromTime: fromTime, day: day, talk: talk)
        
        return sl
    }
    
   
    
    override class func entityName() -> String {
        return "Slot"
    }
    
    override class func fileName() -> String {
        return entityName()
    }
    
    override class func prepareArray(json : JSON) -> [JSON]? {
        return json["slots"].array
    }
    
    override class func save(dataHelper : DataHelper) -> Void {
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = Feedable(entity: entity!, insertIntoManagedObjectContext: managedContext)
        coreDataObject.feed(dataHelper)
        
        if let slotHelper = dataHelper as? SlotHelper {
            let ent2 = NSEntityDescription.entityForName("Talk", inManagedObjectContext: managedContext)
            let coreDataObject2 = Feedable(entity: ent2!, insertIntoManagedObjectContext: managedContext)
            
            //print(coreDataObject2)
            
            
            //print(slotHelper.talk)
            
            
            coreDataObject2.feed(slotHelper.talk)
            
            //print(coreDataObject2)
            
            if let coreDataObjectCast = coreDataObject as? Slot {
                if let coreDataObject2Cast = coreDataObject2 as? Talk {
                    //print(coreDataObject2Cast)
                    coreDataObjectCast.talk = coreDataObject2Cast
                }
                
            }
        }
        
        
        generateFavorite(managedContext, object:coreDataObject, type: entityName())
        saveCoreData(managedContext)
 
        
    }
}