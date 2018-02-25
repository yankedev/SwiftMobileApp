//
//  StoredResourceHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-01.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class StoredResourceHelper: DataHelperProtocol {
    
    var url: String?
    var etag: String?
    var fallback: String?
    
    init() {
    }
    
    init(url: String?, etag: String?, fallback : String?) {
        self.url = url ?? ""
        self.etag = etag ?? ""
        self.fallback = fallback ?? ""
    }
    
    func typeName() -> String {
        return entityName()
    }
    func getMainId() -> String {
        return ""
    }
    
    func feed(_ data: JSON) {
        url = data["url"].string
        etag = data["etag"].string
        fallback = data["fallback"].string
    }
    
    func entityName() -> String {
        return "StoredResource"
    }
    
    func prepareArray(_ json: JSON) -> [JSON]? {
        return json.array
    }
    
}
