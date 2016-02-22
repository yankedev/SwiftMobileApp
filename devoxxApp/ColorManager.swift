//
//  ColorManager.swift
//  devoxxApp
//
//  Created by maxday on 12.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class ColorManager {
    
    //this should be fetched from backEnd too ? (and stored in CoreData)
    static var igniteColor = UIColor(red: 255/255, green: 165/255, blue: 204/255, alpha: 1)
    static var conferenceColor = UIColor(red: 251/255, green: 109/255, blue: 54/255, alpha: 1)
    static var quickieColor =  UIColor(red: 85/255, green: 192/255, blue: 194/255, alpha: 1)
    static var keynoteColor = UIColor(red: 212/255, green: 165/255, blue: 113/255, alpha: 1)
    static var handsOnLabColor = UIColor(red: 1/255, green: 210/255, blue: 110/255, alpha: 1)
    static var birdOfAFatherColor = UIColor(red: 243/255, green: 44/255, blue: 44/255, alpha: 1)
    static var toolsInActionColor = UIColor(red: 245/255, green: 215/255, blue: 51/255, alpha: 1)
    static var universityColor = UIColor(red: 168/255, green: 80/255, blue: 161/255, alpha: 1)
    static var homeFontColor = UIColor(red: 248/255, green: 185/255, blue: 17/255, alpha: 1)
    static var defaultColor = UIColor.clearColor()
    
    static var topNavigationBarColor = UIColor(red: 246/255, green: 174/255, blue: 53/255, alpha: 1)
    
    static var bottomDotsPageController = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    
    static var favoriteBackgroundColor = UIColor(red: 251/255, green: 207/255, blue: 148/255, alpha: 0.4)
    static var filterBackgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
    
    static var breakColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
    
    
    
    
    class func getColorFromTalkType(talkType : String) -> UIColor {
        if(talkType == "Ignite Sessions") {
            return igniteColor
        }
        if(talkType == "Conference") {
            return conferenceColor
        }
        if(talkType == "University") {
            return universityColor
        }
        if(talkType == "Quickie") {
            return quickieColor
        }
        if(talkType == "Keynote") {
            return keynoteColor
        }
        if(talkType == "Hand's on Labs") {
            return handsOnLabColor
        }
        if(talkType == "BOF (Bird of a Feather)") {
            return birdOfAFatherColor
        }
        if(talkType == "Tools-in-Action") {
            return toolsInActionColor
        }
        return breakColor
    }

    
    class func getColorFromTrackTitle(trackTitle : String) -> UIColor {
        if(trackTitle == "Ignite Sessions") {
            return igniteColor
        }
        if(trackTitle == "Conference") {
            return conferenceColor
        }
        if(trackTitle == "University") {
            return universityColor
        }
        if(trackTitle == "Quickie") {
            return quickieColor
        }
        if(trackTitle == "Keynote") {
            return keynoteColor
        }
        if(trackTitle == "Hand's on Labs") {
            return handsOnLabColor
        }
        if(trackTitle == "BOF (Bird of a Feather)") {
            return birdOfAFatherColor
        }
        if(trackTitle == "Tools-in-Action") {
            return toolsInActionColor
        }
        return defaultColor
    }

    
}