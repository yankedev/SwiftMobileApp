//
//  Cfp.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


class Cfp: NSManagedObject {

    @NSManaged var id: String?
    @NSManaged var confType: String?
    @NSManaged var confDescription: String?
    @NSManaged var venue: String?
    @NSManaged var address: NSNumber?
    @NSManaged var country: String?
    @NSManaged var capacity: String?
    @NSManaged var sessions: String?


}
