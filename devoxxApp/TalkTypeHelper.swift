//
//  TalkTypeHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class TalkTypeHelper: DataHelper {
    
    let id: String
    let label: String
    let talkTypeDescription: String
    
    override var description: String {
        return "label: \(label)\n id: \(id)\n talkTypeDescription: \(talkTypeDescription)\n"
    }
    
    init(label: String?, id: String?, talkTypeDescription: String?) {
        self.label = label ?? ""
        self.id = id ?? ""
        self.talkTypeDescription = talkTypeDescription ?? ""
    }
    
    override class func feed(data: JSON) -> TalkTypeHelper? {
        
        let id: String? = data["id"].string
        let label: String? = data["label"].string
        let talkTypeDescription: String? = data["talkTypeDescription"].string
        
        return TalkTypeHelper(label: label, id: id, talkTypeDescription: talkTypeDescription)
    }
    
    override class func entityName() -> String {
        return "TalkType"
    }
    
    override class func prepareArray(json : JSON) -> [JSON]? {
        return json["proposalTypes"].array
    }
    
}