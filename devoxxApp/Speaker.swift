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

public class Speaker: NSManagedObject, CellDataPrococol, FeedableProtocol, FavoriteProtocol, SearchableItemProtocol, ImageFeedable, DetailableProtocol {
    
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
    
    public func getTwitter() -> String {
        return "\((cfp?.hashtag)!) \(displayTwitter())"
    }
    
    public func getTitle() -> String {
        return getFullName()
    }
    
    public func getSubTitle() -> String {
        return speakerDetail.company
    }
    
    public func getSummary() -> String {
        return speakerDetail.bio
    }
    
    public func detailInfos() -> [String] {
        return []
    }
    
    public func getDetailInfoWithIndex(idx: Int) -> String? {
        if idx < detailInfos().count {
            return detailInfos()[idx]
        }
        return nil
    }
    
    public func getObjectId() -> NSManagedObjectID {
        return objectID
    }
    
    public func getRelatedDetailWithIndex(idx : Int) -> DetailableProtocol? {
        if let speakerArray = talks.sortedArrayUsingDescriptors([NSSortDescriptor(key: "title", ascending: true)]) as? [Talk] {
            
            if idx < speakerArray.count {
                return speakerArray[idx]
            }
            
            return nil
        }
        return nil
    }
    
    public func getFullLink() -> String? {
        return href
    }
    
    public func getImageFullLink() -> String? {
        return avatarUrl
    }
    
    
    public func getRelatedDetailsCount() -> Int {
        return talks.count
    }
    
    
    
    
    
    
    public func getObjectID() -> NSManagedObjectID {
        return objectID
    }
    
    func feedImageData(data: NSData) {
        imgData = data
    }
    
    public func getFirstInformation() -> String {
        return "\(firstName!.capitalizedString) \(lastName!.capitalizedString)"
    }
    
    public func getId() -> NSManagedObject? {
        return nil
    }
    public func resetId(id: NSManagedObject?) {
    }
    
    public func getUrl() -> String? {
        if avatarUrl != nil {
            if avatarUrl!.hasPrefix("https") && (avatarUrl!.hasSuffix("png") || avatarUrl!.hasSuffix("jpg") || avatarUrl!.hasSuffix("jpeg") || avatarUrl!.hasSuffix("gif")) {
                return avatarUrl
            }
        }
        return ""
    }
    
    
    public func getSecondInformation() -> String {
        return ""
    }
    
    public  func getForthInformation(useTwitter : Bool) -> String {
        return ""
    }
    
    public  func getThirdInformation() -> String  {
        return ""
    }
    
    public  func getPrimaryImage() -> UIImage? {
        return UIImage(data: imgData)
    }
    public  func getColor() -> UIColor? {
        return nil
    }
    
    public  func isSpecial() -> Bool {
        return false
    }
    
    public func getElement() -> NSManagedObject {
        return self
    }
    
    public func feedHelper(help: DataHelperProtocol) {
        if let castHelper = help as? SpeakerHelper  {
            uuid = castHelper.uuid
            firstName = castHelper.firstName
            lastName = castHelper.lastName
            avatarUrl = castHelper.avatarUrl
            href = castHelper.href
        }
    }
    
    public func getIdentifier() -> String {
        return uuid!
    }
    
    public func invertFavorite() {
        isFavorited = !isFavorited
    }
    
    public func isFav() -> Bool {
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
    
    public func getHeaderTitle() -> String {
        return "Talks"
    }
    
    
    
    
    
    
    
}
