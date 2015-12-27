//
//  Talk.swift
//  devoxxApp
//
//  Created by maxday on 11.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class Talk: NSManagedObject, FavoriteProtocol {

    @NSManaged var id: String
    @NSManaged var lang: String
    @NSManaged var summary: String
    @NSManaged var talkType: String
    @NSManaged var title: String
    @NSManaged var track: String
    @NSManaged var trackId: String
    @NSManaged var isFavorite: NSNumber
    
    func getIconFromTrackId() -> String {
        return "icon_\(trackId)"
    }
    
    func getShortTalkTypeName() -> String {
        if(talkType == "Ignite Sessions") {
            return "Ignite"
        }
        if(talkType == "Conference") {
            return "Conference"
        }
        if(talkType == "Quickie") {
            return "Quickie"
        }
        if(talkType == "Keynote") {
            return "Keynote"
        }
        if(talkType == "University") {
            return "University"
        }
        if(talkType == "Tools-in-Action") {
            return "Tools"
        }
        if(talkType == "Hand's on Labs") {
            return "HOL"
        }
        if(talkType == "BOF (Bird of a Feather)") {
            return "BOF"
        }
        return talkType
    }
    
    func getIdentifier() -> String {
        return id
    }
    func favorited() -> Bool {
        return APIManager.isFavorited("Talk", identifier: getIdentifier())
    }


}
