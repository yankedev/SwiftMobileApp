//
//  SpeakerHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SpeakerHelper: DataHelperProtocol, DetailableProtocol {
    
    var uuid: String?
    var lastName: String?
    var firstName: String?
    var avatarUrl: String?
    var objectID : NSManagedObjectID!
    var href: String?
    var speakerDetailHelper: SpeakerDetailHelper?
    var isFav : Bool?
    var talksId : [String]?
    var relatedObjects: [DataHelperProtocol]?
    
    func getMainId() -> String {
        return uuid!
    }
    
    init() {
    }
    
    init(uuid: String?, lastName: String?, firstName: String?, avatarUrl: String?, href: String?, speakerDetailHelper: SpeakerDetailHelper?, isFav: Bool, talksId : [String]?) {
        self.uuid = uuid ?? ""
        self.lastName = lastName ?? ""
        self.firstName = firstName ?? ""
        self.avatarUrl = avatarUrl ?? ""
        self.href = href ?? ""
        self.speakerDetailHelper = speakerDetailHelper
        self.isFav = isFav
        self.talksId = talksId
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
    
    
    
    
    
    
    
    
    //detailable
    func getTwitter() -> String? {
        return ""
        //return "\((cfp?.hashtag)!) \(displayTwitter())"
    }
    
    func getTitle() -> String? {
        return "\(firstName!) \(lastName!)"
    }
    
    func getSubTitle() -> String? {
        return speakerDetailHelper?.company
    }
    
    func getSummary() -> String? {
        return speakerDetailHelper?.bio
    }
    
    func detailInfos() -> [String] {
        return []
    }
    
    func getDetailInfoWithIndex(idx: Int) -> String? {
        if idx < detailInfos().count {
            return detailInfos()[idx]
        }
        return nil
    }
    
    func getObjectId() -> NSManagedObjectID {
        return objectID
    }
    
    func getRelatedDetailWithIndex(idx : Int) -> DetailableProtocol? {
        if idx < relatedObjects?.count {
            return relatedObjects?[idx] as? DetailableProtocol
        }
        return nil
    }
    
    func getFullLink() -> String? {
        return href
    }
    
    func getImageFullLink() -> String? {
        return avatarUrl
    }
    
    
    func getRelatedDetailsCount() -> Int {
        if talksId != nil {
            return talksId!.count
        }
        return 0
    }
    
    func getHeaderTitle() -> String? {
        return "Talks"
    }

    func getPrimaryImage() -> UIImage? {
        return nil
    }
    
    func getRelatedIds() -> [String] {
        if talksId == nil {
            return [String]()
        }
        return talksId!
    }
    
    func setRelated(data : [DataHelperProtocol]){
        relatedObjects = data
    }
    
}