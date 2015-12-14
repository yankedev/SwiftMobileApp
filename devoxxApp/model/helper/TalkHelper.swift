//
//  TalkHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation

class TalkHelper: NSObject {
    
    let title: String
    let lang: String
    let trackId: String
    let talkType: String
    let track: String
    let id: String
    let summary: String
    let isFavorite: Bool
    
    override var description: String {
        return "title: \(title)\n lang: \(lang)\n trackId: \(trackId)\n title: \(talkType)\n talkType: \(title)\n id: \(id)\n title: \(title)\n summary: \(summary)\n"
    }
    
    init(title: String?, lang: String?, trackId: String?, talkType: String?, track: String?, id: String?, summary: String?) {
        self.title = title ?? ""
        self.lang = lang ?? ""
        self.trackId = trackId ?? ""
        self.talkType = talkType ?? ""
        self.track = track ?? ""
        self.id = id ?? ""
        self.summary = summary ?? ""
        self.isFavorite = false
    }
    
    class func feed(data: JSON) -> TalkHelper {
      
        var title: String? = data["talk"]["title"].string
        if(title == nil) {
            title = data["break"]["nameEN"].string
        }
        let lang: String? = data["talk"]["lang"].string
        let trackId: String? = data["talk"]["trackId"].string
        let talkType: String? = data["talk"]["talkType"].string
        let track: String? = data["talk"]["track"].string
        let id: String? = data["talk"]["id"].string
        let summary: String? = data["talk"]["summary"].string

        return TalkHelper(title: title, lang: lang, trackId: trackId, talkType: talkType, track: track, id: id, summary: summary)
    }
    
}