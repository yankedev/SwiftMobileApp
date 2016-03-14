//
//  SpeakerHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation

class SpeakerHelper: DataHelperProtocol {
    
    var uuid: String?
    var lastName: String?
    var firstName: String?
    var avatarUrl: String?
    var href: String?
    
    func getMainId() -> String {
        return uuid!
    }
    
    func feed(data: JSON) {
        uuid = data["uuid"].string
        lastName = data["lastName"].string?.capitalizedString
        firstName = data["firstName"].string?.capitalizedString
        avatarUrl = data["avatarURL"].string
        href = data["links"][0]["href"].string
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    func entityName() -> String {
        return "Speaker"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json.array
    }
    
}