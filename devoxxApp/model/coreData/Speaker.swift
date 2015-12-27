//
//  Speaker.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class Speaker: CellData, FavoriteProtocol {

    @NSManaged var uuid: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var avatarUrl: String?
    
    override func getFirstInformation() -> String {
        return "\(firstName!.capitalizedString) \(lastName!.capitalizedString)"
    }
    
    override func feed(helper: DataHelper) -> Void {
        if let castHelper = helper as? SpeakerHelper  {
            uuid = castHelper.uuid
            firstName = castHelper.firstName
            lastName = castHelper.lastName
            avatarUrl = castHelper.avatarUrl
        }
    }
    
    func getIdentifier() -> String {
        return uuid!
    }
    
    func favorited() -> Bool {
        return APIManager.isFavorited("Speaker", identifier: getIdentifier())
    }

}
