//
//  Track.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

class Track: Feedable {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var trackDescription: String?
    
    
    override func feed(helper: DataHelper) -> Void {
        if let castHelper = helper as? TrackHelper  {
            id = castHelper.id
            title = castHelper.title
            trackDescription = castHelper.trackDescription
        }
    }
    
}
