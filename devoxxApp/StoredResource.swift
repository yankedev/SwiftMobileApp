//
//  StoredResource.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-01.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class StoredResource: NSManagedObject, FeedableProtocol {
    
    @NSManaged var url: String
    @NSManaged var etag: String
    @NSManaged var fallback: String
    @NSManaged var hasBeenFedOnce: Bool

    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? StoredResourceHelper  {
            url = castHelper.url ?? ""
            etag = castHelper.etag ?? ""
            fallback = castHelper.fallback ?? ""
        }
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    
    func resetId(id: NSManagedObject?) {
    }
    
    
}
