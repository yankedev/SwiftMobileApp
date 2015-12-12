//
//  SlotHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation

class SlotHelper: NSObject, Printable {
    let roomName: String
    let slotId: String
    let fromTime: String
    let talk : TalkHelper
    
    override var description: String {
        return "roomName: \(roomName)\n slotId: \(slotId)\n fromTime: \(fromTime) \n talk: \(talk)\n"
    }
    
    init(roomName: String?, slotId: String?, fromTime: String?, talk: TalkHelper) {
        self.roomName = roomName ?? ""
        self.slotId = slotId ?? ""
        self.fromTime = fromTime ?? ""
        self.talk = talk
    }
    
    class func feed(data: JSON, talk: TalkHelper) -> SlotHelper {
        var roomName: String? = data["roomName"].string
        var slotId: String? = data["slotId"].string
        var fromTime: String? = data["fromTime"].string
        
        return SlotHelper(roomName: roomName, slotId: slotId, fromTime: fromTime, talk: talk)
    }
}