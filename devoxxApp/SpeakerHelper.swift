//
//  SpeakerHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class SpeakerHelper: DataHelper {
    
    let uuid: String
    let lastName: String
    let firstName: String
    let avatarUrl: String
    
    override var description: String {
        return "uuid: \(uuid)\n lastName: \(lastName)\n firstName: \(firstName)\n avatarUrl: \(avatarUrl)\n"
    }
    
    init(uuid: String?, lastName: String?, firstName: String?, avatarUrl: String?) {
        self.uuid = uuid ?? ""
        self.lastName = lastName ?? ""
        self.firstName = firstName ?? ""
        self.avatarUrl = avatarUrl ?? ""
    }
    
    override class func feed(data: JSON) -> SpeakerHelper? {
        
        let uuid: String? = data["uuid"].string
        let lastName: String? = data["lastName"].string
        let firstName: String? = data["firstName"].string
        let avatarUrl: String? = data["avatarUrl"].string
        
        return SpeakerHelper(uuid: uuid, lastName: lastName, firstName: firstName, avatarUrl: avatarUrl)
    }
    
    override class func entityName() -> String {
        return "Speaker"
    }
    
    override class func prepareArray(json : JSON) -> [JSON]? {
        return json.array
    }
    
    override class func save(dataHelper : DataHelper) -> Void {
        print("speaker")
        super.save(dataHelper)
    }
    
}