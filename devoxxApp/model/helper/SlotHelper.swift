//
//  SlotHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation

class SlotHelper: NSObject {
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
    
    class func feed(data: JSON, talk: TalkHelper) -> SlotHelper {
        let roomName: String? = data["roomName"].string
        let slotId: String? = data["slotId"].string
        let fromTime: String? = data["fromTime"].string
        let day: String? = data["day"].string
        
        return SlotHelper(roomName: roomName, slotId: slotId, fromTime: fromTime, day: day, talk: talk)
    }
}