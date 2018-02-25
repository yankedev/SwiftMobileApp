//
//  TrackHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation

class TrackHelper: AttributeHelper, DataHelperProtocol {
    
    func getMainId() -> String {
        return id!
    }
    
    func feed(_ data: JSON) {
        super.label = data["title"].string
        super.id = data["id"].string
        super.attributeDescription = data["trackDescription"].string
        
        super.type = "Track"
    }
    
    func entityName() -> String {
        return "Attribute"
    }
    
    func typeName() -> String {
        return "Track"
    }
    
    func prepareArray(_ json : JSON) -> [JSON]? {
        return json["tracks"].array
    }
    
    func filterPredicate() -> String {
        return "talk.trackId"
    }
    
}
