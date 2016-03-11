//
//  Speaker.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Speaker: NSManagedObject, CellDataPrococol, FeedableProtocol, FavoriteProtocol, SearchableItemProtocol, ImageFeedable, DetailableProtocol {

    @NSManaged var uuid: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var avatarUrl: String?
    @NSManaged var href: String?
    @NSManaged var cfp: Cfp?
    @NSManaged var isFavorited: Bool
    @NSManaged var speakerDetail: SpeakerDetail
    @NSManaged var talks: NSSet
    @NSManaged var imgData: NSData

    
    func getTitle() -> String {
        return getFullName()
    }
    
    func getSubTitle() -> String {
        return speakerDetail.company
    }
    
    func getSummary() -> String {
        return speakerDetail.bio
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
        if let speakerArray = talks.sortedArrayUsingDescriptors([NSSortDescriptor(key: "title", ascending: true)]) as?[DetailableProtocol] {
            
            if idx < speakerArray.count {
                return speakerArray[idx]
            }
            
            return nil
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
        return talks.count
    }
    
    
    
    
    
    
    func getObjectID() -> NSManagedObjectID {
        return objectID
    }
    
    func feedImageData(data: NSData) {
        imgData = data
    }
    
    func getFirstInformation() -> String {
        return "\(firstName!.capitalizedString) \(lastName!.capitalizedString)"
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    func resetId(id: NSManagedObject?) {
    }
    
    func getUrl() -> String? {
        if avatarUrl != nil {
            if avatarUrl!.hasPrefix("https") && (avatarUrl!.hasSuffix("png") || avatarUrl!.hasSuffix("jpg") || avatarUrl!.hasSuffix("jpeg") || avatarUrl!.hasSuffix("gif")) {
                return avatarUrl
            }
        }
        return ""
    }

    
    func getSecondInformation() -> String {
        return ""
    }
    
    func getForthInformation(useTwitter : Bool) -> String {
        return ""
    }
    
    func getThirdInformation() -> String  {
        return ""
    }
    
    func getPrimaryImage() -> UIImage? {
        return UIImage(data: imgData)
    }
    func getColor() -> UIColor? {
        return nil
    }
    
    func isSpecial() -> Bool {
        return false
    }

    func getElement() -> NSManagedObject {
        return self
    }

    func feedHelper(help: DataHelperProtocol) {
        if let castHelper = help as? SpeakerHelper  {
            uuid = castHelper.uuid
            firstName = castHelper.firstName
            lastName = castHelper.lastName
            avatarUrl = castHelper.avatarUrl
            href = castHelper.href
        }
    }
    
    func getIdentifier() -> String {
        return uuid!
    }
    
    func invertFavorite() {
        isFavorited = !isFavorited
    }
    
    func isFav() -> Bool {
        return isFavorited
    }
    
   
    
    func favorited() -> Bool {
        return isFavorited
    }
    
    func displayTwitter() -> String {
        if speakerDetail.twitter != "" {
            return speakerDetail.twitter
        }
        return getFullName()
    }

    func getFullName() -> String {
        return "\(firstName!) \(lastName!)"
    }
    
    
    func isMatching(str : String) -> Bool {
        return getFullName().lowercaseString.containsString(str.lowercaseString)
    }
    
    
    
    
    

    


}
