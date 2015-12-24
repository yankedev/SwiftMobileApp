//
//  TalkType.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class TalkType: Feedable {
    
    @NSManaged var id: String?
    @NSManaged var label: String?
    @NSManaged var talkTypeDescription: String?
    
    override func feed(helper: DataHelper) -> Void {
        if let castHelper = helper as? TalkTypeHelper  {
            id = castHelper.id
            label = castHelper.label
            talkTypeDescription = castHelper.talkTypeDescription
        }
    }
}
