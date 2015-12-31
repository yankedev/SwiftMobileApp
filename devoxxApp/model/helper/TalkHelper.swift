//
//  TalkHelper.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

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
    
    func typeName() -> String {
        return entityName()
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
      
        title = data["title"].string
        if(title == nil) {
            title = data["nameEN"].string
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
        print(json)
        if(json["talk"] != nil) {
            return [json["talk"]]
        }
        return [json["break"]]
    }
    
    func save2() -> NSManagedObject? {
        return nil
    }
    
    func save(managedContext : NSManagedObjectContext) {
        //
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}