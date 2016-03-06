//
//  Image.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-20.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Image: NSManagedObject, FeedableProtocol {
    
    @NSManaged var img: String
    @NSManaged var etag: String
    @NSManaged var data: NSData
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? ImageHelper  {
            img = castHelper.imgName ?? ""
            etag = castHelper.etag ?? ""
            data = APIManager.dataFromImage(APIManager.getLastFromUrl(img))!
        }
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    func resetId(id: NSManagedObject?) {
    }

    
}
