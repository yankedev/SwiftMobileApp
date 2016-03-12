//
//  ImageHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-20.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import CoreData

class ImageHelper: DataHelperProtocol {
    
    
    var imgName: String?
    var etag: String?
    
    func getMainId() -> String {
        return ""
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    init(img: String?, etag: String?) {
        self.imgName = imgName ?? ""
        self.etag = etag ?? ""
    }
    
    func feed(data: JSON) {
        imgName = data["img"].string
        etag = data["etag"].string
    }
    
    func entityName() -> String {
        return "Image"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
    
    required init() {
    }
    
    
    
}