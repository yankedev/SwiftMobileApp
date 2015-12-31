//
//  Attribute.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData


class Attribute: NSManagedObject, FeedableProtocol {
    
    @NSManaged var id: String?
    @NSManaged var label: String?
    @NSManaged var attributeDescription: String?
    @NSManaged var type: String?
    
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? AttributeHelper  {
            id = castHelper.id
            label = castHelper.label
            attributeDescription = castHelper.attributeDescription
            type = castHelper.type
        }
    }
}
