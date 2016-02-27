//
//  DataHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData



public protocol DataHelperProtocol : NSCopying {
    func feed(data: JSON)
    func entityName() -> String
    func prepareArray(json : JSON) -> [JSON]?
    func save(managedContext : NSManagedObjectContext) -> Bool
    func typeName() -> String
}

