//
//  Floor.swift
//  devoxxApp
//
//  Created by maxday on 21.02.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Floor: NSManagedObject, FeedableProtocol {
    
    @NSManaged var id: String
    @NSManaged var img: String
    @NSManaged var title: String
    @NSManaged var tabpos: String
    @NSManaged var target: String
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? FloorHelper  {
            id = castHelper.id ?? ""
            img = castHelper.img ?? ""
            title = castHelper.title ?? ""
            tabpos = castHelper.tabpos ?? ""
            target = castHelper.target ?? ""
        }
    }
    
    
}
