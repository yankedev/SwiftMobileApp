//
//  Favorite.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-27.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData


class Favorite: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var isFavorited: NSNumber?
    @NSManaged var type: String?
    
}
