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

class Speaker: NSManagedObject, CellDataPrococol, FeedableProtocol, FavoriteProtocol {

    @NSManaged var uuid: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var avatarUrl: String?
    @NSManaged var href: String?
    @NSManaged var eventId: String?
    @NSManaged var speakerDetail: SpeakerDetail
    @NSManaged var talks: NSSet
    @NSManaged var imgData: NSData

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
            if avatarUrl!.hasPrefix("https") {
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
            eventId = APIManager.currentEvent.id!
        }
    }
    
    func getIdentifier() -> String {
        return uuid!
    }
    
    func invertFavorite() -> Bool {
        return APIManager.invertFavorite("Speaker", identifier: getIdentifier())
    }
    
    func favorited() -> Bool {
        return APIManager.isFavorited("Speaker", identifier: getIdentifier())
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
    
    func getTalks() -> Void {
        //return APIManager.getTalksFromSpeaker(self)
    }
    


}
