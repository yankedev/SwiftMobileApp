//
//  Talk.swift
//  devoxxApp
//
//  Created by maxday on 11.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Talk: NSManagedObject, FeedableProtocol{

    @NSManaged var id: String
    @NSManaged var lang: String
    @NSManaged var summary: String
    @NSManaged var talkType: String
    @NSManaged var title: String
    @NSManaged var track: String
    @NSManaged var trackId: String
    @NSManaged var speakers: NSSet
    @NSManaged var isBreak : Bool
    @NSManaged var slot: Slot
    
    func getIconFromTrackId() -> String {
        return "icon_\(trackId)"
    }
    
    func getFriendlySpeaker(delimiter : String, useTwitter : Bool) -> String {
        var returnString = ""
        var isFirst = true
        for spk in speakers {
            if let castSpk = spk as? Speaker {
                let display = (useTwitter && castSpk.speakerDetail.twitter != "") ? castSpk.speakerDetail.twitter : castSpk.getFirstInformation()
                if(isFirst)  {
                    returnString = returnString + display
                    isFirst = false
                }
                else {
                    returnString = returnString + delimiter + display
                }
            }
        }
        return returnString
    }
    
    func getFullLink() -> String {
        return "\(APIManager.currentEvent.talkURL!)\(id)"
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
    
    func invertFavorite() -> Bool {
        return APIManager.invertFavorite("Talk", identifier: getIdentifier())
    }

    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? TalkHelper  {
            id = castHelper.id ?? ""
            lang = castHelper.lang ?? ""
            summary = castHelper.summary ?? ""
            talkType = castHelper.talkType ?? ""
            title = castHelper.title ?? ""
            track = castHelper.track ?? ""
            trackId = castHelper.trackId ?? ""
            isBreak = castHelper.isBreak ?? false
        }
    }
    
    
}
