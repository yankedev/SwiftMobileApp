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
    var day: String?
    var talk : TalkHelper?
    
    
     func description() -> String {
        return "roomName: \(roomName)\n slotId: \(slotId)\n fromTime: \(fromTime) \n talk: \(talk)\n day: \(day)\n"
    }
    
    
    init() {
    }
    
    init(roomName: String?, slotId: String?, fromTime: String?, day: String?, talk: TalkHelper) {
        self.roomName = roomName ?? ""
        self.slotId = slotId ?? ""
        self.fromTime = fromTime ?? ""
        self.day = day ?? ""
        self.talk = talk
    }
    
    func feed(data: JSON) {
        roomName = data["roomName"].string
        slotId = data["slotId"].string
        fromTime = data["fromTime"].string
        day = data["day"].string
   
        let talkHelper = TalkHelper()
        
       
        
        let subData = talkHelper.prepareArray(data)
        
       
        if let talkData = subData {
            talkHelper.feed(subData![0])
            talk = talkHelper
        }
        
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
    
    func save() -> Void {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            
        
            
            
            coreDataObjectCast.feedHelper(self)
            
            
            let entityTalk = NSEntityDescription.entityForName(
                "Talk", inManagedObjectContext: managedContext)
            let coreDataObjectTalk = NSManagedObject(entity: entityTalk!, insertIntoManagedObjectContext: managedContext)
            
            if let coreDataObjectTalkCast = coreDataObjectTalk as? FeedableProtocol {
                coreDataObjectTalkCast.feedHelper(self.talk!)
                
                if let currentSlot = coreDataObject as? Slot {
                    currentSlot.talk = coreDataObjectTalkCast as! Talk
                    
                                    }
                
                
            }
            
           
            
            saveCoreData(managedContext)
        }
        
        
        //coreDataObject.feed(dataHelper)
        
        //generateFavorite(managedContext, object:coreDataObject, type: entityName())
        //saveCoreData(managedContext)
    }
    
    func saveCoreData(context:NSManagedObjectContext) {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    /*func save(dataHelper : DataHelper) -> Void {
        
        
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
            generateFavorite(managedContext, object:coreDataObject2, type: "Talk")
            //print(coreDataObject2)
            
            if let coreDataObjectCast = coreDataObject as? Slot {
                if let coreDataObject2Cast = coreDataObject2 as? Talk {
                    //print(coreDataObject2Cast)
                    coreDataObjectCast.talk = coreDataObject2Cast
                }
                
            }
        }
        
        
        
        saveCoreData(managedContext)
 
        
    }*/
}