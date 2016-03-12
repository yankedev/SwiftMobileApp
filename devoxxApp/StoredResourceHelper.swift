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
    
    func typeName() -> String {
        return entityName()
    }
    func getMainId() -> String {
        return ""
    }

    
    init(url: String?, etag: String?, fallback : String?) {
        self.url = url ?? ""
        self.etag = etag ?? ""
        self.fallback = fallback ?? ""
    }
    
    func feed(data: JSON) {
        url = data["url"].string
        etag = data["etag"].string
        fallback = data["fallback"].string
    }
    
    func entityName() -> String {
        return "StoredResource"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
  
    required init() {
    }
   
    
}
