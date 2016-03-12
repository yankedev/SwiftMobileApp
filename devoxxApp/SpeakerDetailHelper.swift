//
//  SpeakerDetailHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-26.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SpeakerDetailHelper: DataHelperProtocol {
    
    var uuid: String?
    var bio: String?
    var bioAsHtml: String?
    var company: String?
    var twitter: String?
    var speaker : Speaker?
    
    func getMainId() -> String {
        return uuid ?? ""
    }

    
    func typeName() -> String {
        return entityName()
    }
    
    init(uuid: String?, bio: String?, bioAsHtml: String?, company: String?, twitter: String?, speaker : Speaker) {
        self.uuid = uuid ?? ""
        self.bio = bio ?? ""
        self.bioAsHtml = bioAsHtml ?? ""
        self.company = company ?? ""
        self.twitter = twitter ?? ""
        self.speaker = speaker
    }
    
    func feed(data: JSON) {
        uuid = data["uuid"].string
        bio = data["bio"].string
        bioAsHtml = data["bioAsHtml"].string
        company = data["company"].string
        twitter = data["twitter"].string
    }
    
    func entityName() -> String {
        return "SpeakerDetail"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        var array = [JSON]()
        array.append(json)
        return array
    }
    
    
    func update(managedContext : NSManagedObjectContext) {
        
        
        
        
        let obj = APIManager.findOne("uuid", value: uuid!, entity: entityName(), context: managedContext)
        if let objManagedObject = obj as? SpeakerDetail {
            speaker = APIManager.findOne("uuid", value: uuid!, entity: "Speaker", context: managedContext) as! Speaker
            objManagedObject.feedHelper(self)
        }
    }
    
    
    required init() {
    }
   
    
}
