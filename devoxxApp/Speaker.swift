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

public class Speaker: NSManagedObject, CellDataPrococol, FeedableProtocol, FavoriteProtocol, ImageFeedable, HelperableProtocol {
    
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
    
    func getFullName() -> String {
        return "\(firstName!) \(lastName!)"
    }
    
    public func getHeaderTitle() -> String {
        return "Talks"
    }
    
    func toHelper() -> DataHelperProtocol {
        
       
        
        var talksId = [NSManagedObjectID]()
       
        for singleTalk in Array(talks) {
            talksId.append(singleTalk.getObjectID())
        }

        return SpeakerHelper(uuid: uuid, lastName: lastName, firstName: firstName, avatarUrl: avatarUrl, objectID : objectID, href: href, bio : speakerDetail.bio , company: speakerDetail.company, twitter : speakerDetail.twitter, isFav: isFavorited, talksId: talksId, imgData: imgData)
    }
    
    
    
    
    
    
}
