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

class SpeakerHelper: DataHelperProtocol, DetailableProtocol, CellDataDisplayPrococol, SearchableItemProtocol {
    
    var uuid: String?
    var lastName: String?
    var firstName: String?
    var avatarUrl: String?
    var objectID : NSManagedObjectID?
    var href: String?
    var bio : String?
    var company : String?
    var isFav : Bool?
    var imgData : NSData?
    var talksId : [NSManagedObjectID]?
    var relatedObjects: [DataHelperProtocol]?
    var twitter : String?
    
    func getMainId() -> String {
        return uuid!
    }
    
    init() {
    }
    
    init(uuid: String?, lastName: String?, firstName: String?, avatarUrl: String?, objectID : NSManagedObjectID, href: String?, bio: String?, company: String?, twitter : String?, isFav: Bool, talksId : [NSManagedObjectID]?, imgData : NSData?) {
        self.uuid = uuid ?? ""
        self.lastName = lastName ?? ""
        self.firstName = firstName ?? ""
        self.objectID = objectID
        self.avatarUrl = avatarUrl ?? ""
        self.href = href ?? ""
        self.bio = bio ?? ""
        self.twitter = twitter ?? ""
        self.company = company ?? ""
        self.isFav = isFav
        self.talksId = talksId
        self.imgData = imgData
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
    
    
    
    
    
    func displayTwitter() -> String {
        if twitter != nil && twitter != "" {
            return twitter!
        }
        return getTitle()!
    }
    
    
    //detailable
    func getTwitter() -> String? {
        let hashtag = CfpService.sharedInstance.getHashtag()
        return "\(hashtag) \(displayTwitter())"
    }
    
    func getTitle() -> String? {
        return "\(firstName!) \(lastName!)"
    }
    
    func getSubTitle() -> String? {
        return company
    }
    
    func getSummary() -> String? {
        return bio
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
    
    func getObjectId() -> NSManagedObjectID? {
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
        if imgData == nil {
            return nil
        }
        return UIImage(data: imgData!)
    }
    
    func getRelatedIds() -> [NSManagedObjectID] {
        if talksId == nil {
            return [NSManagedObjectID]()
        }
        return talksId!
    }
    
    func getObjectID() -> NSManagedObjectID? {
        return objectID
    }
    
    func setRelated(data : [DataHelperProtocol]){
        relatedObjects = data
    }
    
    
    func getFirstInformation() -> String? {
        return getTitle()
    }
    
    func getUrl() -> String? {
        if avatarUrl != nil {
            if avatarUrl!.hasPrefix("https") && (avatarUrl!.hasSuffix("png") || avatarUrl!.hasSuffix("jpg") || avatarUrl!.hasSuffix("jpeg") || avatarUrl!.hasSuffix("gif")) {
                return avatarUrl
            }
        }
        return nil
    }
    func isFavorited() -> Bool {
        return isFav!
    }
    
    func isMatching(str : String) -> Bool {
        return getTitle()!.lowercaseString.containsString(str.lowercaseString)
    }
    
}