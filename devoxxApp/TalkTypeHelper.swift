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
    
    override func feed(data: JSON) {
        id = data["id"].string
        label = data["label"].string
        //talkTypeDescription = data["talkTypeDescription"].string
    }
    
    override func entityName() -> String {
        return "Attribute"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json["proposalTypes"].array
    }
    
}