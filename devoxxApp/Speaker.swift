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

open class Speaker: NSManagedObject, CellDataPrococol, FeedableProtocol, FavoriteProtocol, ImageFeedable, HelperableProtocol {
    
    @NSManaged var uuid: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var avatarUrl: String?
    @NSManaged var href: String?
    @NSManaged var cfp: Cfp?
    @NSManaged var isFavorited: Bool
    @NSManaged var speakerDetail: SpeakerDetail
    @NSManaged var talks: NSSet
    @NSManaged var imgData: Data
    
    open func getObjectID() -> NSManagedObjectID {
        return objectID
    }
    
    func feedImageData(_ data: Data) {
        imgData = data
    }
    
    open func getFirstInformation() -> String {
        return "\(firstName!.capitalized) \(lastName!.capitalized)"
    }
    
    open func getId() -> NSManagedObject? {
        return nil
    }
    open func resetId(_ id: NSManagedObject?) {
    }
    
    open func getUrl() -> String? {
       return avatarUrl
    }
    
    
    open func getSecondInformation() -> String {
        return ""
    }
    
    open  func getForthInformation(_ useTwitter : Bool) -> String {
        return ""
    }
    
    open  func getThirdInformation() -> String  {
        return ""
    }
    
    open  func getPrimaryImage() -> UIImage? {
        return UIImage(data: imgData)
    }
    open  func getColor() -> UIColor? {
        return nil
    }
    
    open  func isSpecial() -> Bool {
        return false
    }
    
    open func getElement() -> NSManagedObject {
        return self
    }
    
    open func feedHelper(_ help: DataHelperProtocol) {
        if let castHelper = help as? SpeakerHelper  {
            uuid = castHelper.uuid
            firstName = castHelper.firstName
            lastName = castHelper.lastName
            avatarUrl = castHelper.avatarUrl
            href = castHelper.href
        }
    }
    
    open func getIdentifier() -> String {
        return uuid!
    }
    
    open func invertFavorite() {
        isFavorited = !isFavorited
    }
    
    open func isFav() -> Bool {
        return isFavorited
    }
    
    
    
    func favorited() -> Bool {
        return isFavorited
    }
    
    func getFullName() -> String {
        return "\(firstName!) \(lastName!)"
    }
    
    open func getHeaderTitle() -> String {
        return "Talks"
    }
    
    func toHelper() -> DataHelperProtocol {
        
       
        
        var talksId = [NSManagedObjectID]()
       
        for singleTalk in Array(talks) {
            talksId.append((singleTalk as AnyObject).getObjectID())
        }

        return SpeakerHelper(uuid: uuid, lastName: lastName, firstName: firstName, avatarUrl: avatarUrl, objectID : objectID, href: href, bio : speakerDetail.bio , company: speakerDetail.company, twitter : speakerDetail.twitter, isFavorite: isFavorited, talksId: talksId, imgData: imgData)
    }
    
    
    
    
    
    
}
