//
//  TalkHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation

class TalkHelper: DataHelperProtocol {
    
    var title: String?
    var lang: String?
    var trackId: String?
    var talkType: String?
    var track: String?
    var id: String?
    var summary: String?
    
    /*
    override var description: String {
        return "title: \(title)\n lang: \(lang)\n trackId: \(trackId)\n title: \(talkType)\n talkType: \(title)\n id: \(id)\n title: \(title)\n summary: \(summary)\n"
    }
    */
    
    init() {
    }
    
    init(title: String?, lang: String?, trackId: String?, talkType: String?, track: String?, id: String?, summary: String?) {
        self.title = title ?? ""
        self.lang = lang ?? ""
        self.trackId = trackId ?? ""
        self.talkType = talkType ?? ""
        self.track = track ?? ""
        self.id = id ?? ""
        self.summary = summary ?? ""
    }
    
    func feed(data: JSON) {
      
        var title: String? = data["title"].string
        if(title == nil) {
            title = "TODO brak"
        }
        lang = data["lang"].string
        trackId = data["trackId"].string
        talkType = data["talkType"].string
        track = data["track"].string
        id = data["id"].string
        summary = data["summary"].string

    }
    
    func entityName() -> String {
        return "Talk"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return [json["talk"]]
    }
    
    func save() {
        //
    }
    
}