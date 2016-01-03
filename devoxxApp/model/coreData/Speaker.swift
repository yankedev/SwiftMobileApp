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
    
    func getFirstInformation() -> String {
        return "\(firstName!.capitalizedString) \(lastName!.capitalizedString)"
    }
    
    
    func getSecondInformation() -> String {
        return ""
    }
    
    func getThirdInformation() -> String  {
        return ""
    }
    
    func getPrimaryImage() -> UIImage? {
        return nil
    }
    func getColor() -> UIColor? {
        return nil
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
    
    func invertFavorite() -> Bool {
        return APIManager.invertFavorite("Speaker", identifier: getIdentifier())
    }
    
    func favorited() -> Bool {
        return APIManager.isFavorited("Speaker", identifier: getIdentifier())
    }
    
    

}
