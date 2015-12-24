//
//  TalkType.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

class TalkType: CellData {

    @NSManaged var id: String?
    @NSManaged var label: String?
    @NSManaged var talkTypeDescription: String?

}
