//
//  TrackHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class TrackHelper: AttributeHelper {
  
    
    init(title: String?, id: String?, trackDescription: String?) {
        super.init(id: id, label: title, attributeDescription: trackDescription, type: "Track")
    }
    
    class func feed(data: JSON) -> TrackHelper? {
        
        let title: String? = data["title"].string
        let id: String? = data["id"].string
        let trackDescription: String? = data["trackDescription"].string
        
        return TrackHelper(title: title, id: id, trackDescription: trackDescription)
    }

    override func entityName() -> String {
        return "Attribute"
    }
    
    func fileName() -> String {
        return "Track"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json["tracks"].array
    }
    
    override func save() {
        //
    }
    
}