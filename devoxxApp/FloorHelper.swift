//
//  FloorHelper.swift
//  devoxxApp
//
//  Created by maxday on 21.02.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

class FloorHelper: DataHelperProtocol {
    
    var id: String?
    var img: String?
    var title: String?
    var tabpos: String?
    var target: String?
    
    func getMainId() -> String {
        return id!
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    init(img: String?, etag: String?) {
        self.id = id ?? ""
        self.img = img ?? ""
        self.title = title ?? ""
        self.tabpos = tabpos ?? ""
        self.target = target ?? ""
    }
    
    func feed(_ data: JSON) {
        img = data["img"].string
        title = data["title"].string
        tabpos = data["tabpos"].string
        target = data["target"].string
    }
    
    func entityName() -> String {
        return "Floor"
    }
    
    func prepareArray(_ json: JSON) -> [JSON]? {
        return json.array
    }
    
    required init() {
    }
    
}
