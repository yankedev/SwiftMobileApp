//
//  HelperManager.swift
//  My_Devoxx
//
//  Created by Maxime on 15/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

class HelperManager {

    class func getShortTalkTypeName(talkType : String) -> String {
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


}