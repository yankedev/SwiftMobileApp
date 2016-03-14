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

@objc public protocol DetailableProtocol {
    func getTitle() -> String
    func getSubTitle() -> String
    func getSummary() -> String
    func detailInfos() -> [String]
    func getDetailInfoWithIndex(idx : Int) -> String?
    func getObjectId() -> NSManagedObjectID
    func getRelatedDetailsCount() -> Int
    func getRelatedDetailWithIndex(idx : Int) -> DetailableProtocol?
    func getFullLink() -> String?
    func getImageFullLink() -> String?
    func getPrimaryImage() -> UIImage?
    func getTwitter() -> String
    func getHeaderTitle() -> String
}

protocol RatableProtocol {
    func getTitle() -> String
}

class Talk: NSManagedObject, FeedableProtocol, FavoriteProtocol, CellDataPrococol, SearchableItemProtocol, DetailableProtocol, RatableProtocol {
    
    @NSManaged var id: String
    @NSManaged var lang: String
    @NSManaged var summary: String
    @NSManaged var talkType: String
    @NSManaged var title: String
    @NSManaged var track: String
    @NSManaged var trackId: String
    @NSManaged var speakers: NSSet
    @NSManaged var isFavorited: Bool
    @NSManaged var isBreak : Bool
    @NSManaged var slot: Slot
    
    func getTitle() -> String {
        return title
    }
    
    func getSubTitle() -> String {
        return track
    }
    
    func getSummary() -> String {
        return summary
    }
    
    func getTwitter() -> String {
        return "\((slot.cfp?.hashtag)!) \(getTitle()) by \(getForthInformation(true)) \(getFullLink()!)"
    }
    
    func detailInfos() -> [String] {
        return [slot.roomName, getShortTalkTypeName(), slot.getFriendlyTime(), getForthInformation(false)]
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
        if let speakerArray = speakers.sortedArrayUsingDescriptors([NSSortDescriptor(key: "title", ascending: true)]) as?[DetailableProtocol] {
            
            if idx < speakerArray.count {
                return speakerArray[idx]
            }
            
            return nil
        }
        
        return nil
    }
    
    
    func getFullLink() -> String? {
        return "\(slot.cfp!.cfpEndpoint!)/conferences/\(slot.cfp!.id!)/talks/\(id)"
    }
    
    func getImageFullLink() -> String? {
        return nil
    }
    
    func getRelatedDetailsCount() -> Int {
        return speakers.count
    }
    
    func getIconFromTrackId() -> String {
        return "icon_\(trackId)"
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    
    func resetId(id: NSManagedObject?) {
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
    
    func invertFavorite() {
        isFavorited = !isFavorited
    }
    
    func isFav() -> Bool {
        return isFavorited
    }
    
    
    
    
    
    
    func getForthInformation(useTwitter : Bool) -> String {
        return getFriendlySpeaker(", ", useTwitter : useTwitter)
    }
    
    func getPrimaryImage() -> UIImage? {
        return UIImage(named: getIconFromTrackId())
    }
    
    func getFirstInformation() -> String {
        return title
    }
    
    func getSecondInformation() -> String {
        return slot.roomName
    }
    
    func getThirdInformation() -> String {
        return track
    }
    
    func isMatching(str : String) -> Bool {
        return getFirstInformation().lowercaseString.containsString(str.lowercaseString)
    }
    
    
    func getColor() -> UIColor? {
        return ColorManager.getColorFromTalkType(talkType)
    }
    
    func getElement() -> NSManagedObject {
        return self
    }
    
    func getObjectID() -> NSManagedObjectID {
        return objectID
    }
    
    func getUrl() -> String? {
        return ""
    }
    
    func isSpecial() -> Bool {
        return isBreak
    }
    
    public func getHeaderTitle() -> String {
        return "Speakers"
    }
    
    
    
}
