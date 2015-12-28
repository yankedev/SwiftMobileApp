//
//  TalkHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation

class TalkHelper: DataHelper {
    
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
    
    override class func feed(data: JSON) -> TalkHelper {
      
        var title: String? = data["title"].string
        if(title == nil) {
            title = "TODO brak"
        }
        let lang: String? = data["lang"].string
        let trackId: String? = data["trackId"].string
        let talkType: String? = data["talkType"].string
        let track: String? = data["track"].string
        let id: String? = data["id"].string
        let summary: String? = data["summary"].string

        return TalkHelper(title: title, lang: lang, trackId: trackId, talkType: talkType, track: track, id: id, summary: summary)
    }
    
}