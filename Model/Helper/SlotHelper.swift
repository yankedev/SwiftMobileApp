//
//  SlotHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation

class SlotHelper: DataHelperProtocol {
    
    var roomName: String?
    var slotId: String?
    var fromTime: String?
    var toTime: String?
    var day: String?
    var fromTimeMillis : NSNumber?
    var talk : TalkHelper?
    
    init() {
    }
    
    init(roomName: String?, slotId: String?, fromTime: String?, toTime:String?, day: String?, talk: TalkHelper) {
        self.roomName = roomName ?? ""
        self.slotId = slotId ?? ""
        self.fromTime = fromTime ?? ""
        self.toTime = toTime ?? ""
        self.day = day ?? ""
        self.talk = talk
    }
    
    func getMainId() -> String {
        return slotId!
    }
    
    func typeName() -> String {
        return entityName()
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

}