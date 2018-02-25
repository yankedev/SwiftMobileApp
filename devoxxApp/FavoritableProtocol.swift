//
//  FavoritableProtocol.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

public protocol FavoritableProtocol : class {
    func favorite(_ id : NSManagedObjectID) -> Bool
}
