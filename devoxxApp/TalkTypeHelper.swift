//
//  TalkTypeHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class TalkTypeHelper: AttributeHelper {
    
    
    init(label: String?, id: String?, talkTypeDescription: String?) {
        super.init(id: id, label: label, attributeDescription: talkTypeDescription, type: "TalkType")
    }
    
    override class func feed(data: JSON) -> TalkTypeHelper? {
        let id = data["id"].string
        let label = data["label"].string
        let talkTypeDescription = data["talkTypeDescription"].string
        
        return TalkTypeHelper(label: label, id: id, talkTypeDescription: talkTypeDescription)
    }
    
    override class func entityName() -> String {
        return "Attribute"
    }
    
    override class func fileName() -> String {
        return "TalkType"
    }
    
    override class func prepareArray(json : JSON) -> [JSON]? {
        return json["proposalTypes"].array
    }
    
}