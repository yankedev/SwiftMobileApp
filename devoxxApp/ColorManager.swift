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
    static var defaultColor = UIColor.whiteColor()
    
    static var topNavigationBarColor = UIColor(red: 246/255, green: 174/255, blue: 53/255, alpha: 1)
    
    class func getColorFromTalkType(talkType : String) -> UIColor {
        if(talkType == "Ignite Sessions") {
            return igniteColor
        }
        if(talkType == "Conference") {
            return conferenceColor
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
        return defaultColor
    }

}