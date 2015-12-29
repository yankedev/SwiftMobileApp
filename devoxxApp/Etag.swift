//
//  Etag.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-29.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData


class Etag: NSManagedObject {
    
    @NSManaged var url: String?
    @NSManaged var value: String?
    
}

