//
//  TalkTypeHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation

class TalkTypeHelper: AttributeHelper, DataHelperProtocol {
    
    func getMainId() -> String {
        return ""
    }

    func feed(data: JSON) {
        super.label = data["label"].string
        super.id = data["id"].string
        super.attributeDescription = data["description"].string
        super.type = "TalkType"
    }
    
    func entityName() -> String {
        return "Attribute"
    }
    
    func typeName() -> String {
        return "TalkType"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json["proposalTypes"].array
    }

}