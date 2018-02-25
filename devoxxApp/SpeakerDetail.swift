//
//  SpeakerDetail.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-26.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SpeakerDetail: NSManagedObject, FeedableProtocol {
    
    @NSManaged var bio: String
    @NSManaged var bioAsHtml: String
    @NSManaged var company: String
    @NSManaged var twitter: String
    @NSManaged var uuid: String
    @NSManaged var speaker : Speaker
    
    func feedHelper(_ helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? SpeakerDetailHelper  {
            bio = castHelper.bio ?? ""
            bioAsHtml = castHelper.bioAsHtml ?? ""
            company = castHelper.company ?? ""
            twitter = castHelper.twitter ?? ""
            uuid = castHelper.uuid ?? ""
            if castHelper.speaker != nil {
                speaker = castHelper.speaker!
            }
        }
    }
    
    func getId() -> NSManagedObject? {
        return speaker
    }
    
    func resetId(_ id: NSManagedObject?) {
        self.speaker = id as! Speaker
    }
    
    
}
