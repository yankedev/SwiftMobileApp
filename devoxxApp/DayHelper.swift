//
//  DayHelper.swift
//  devoxxApp
//
//  Created by maxday on 02.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DayHelper: DataHelperProtocol {
    
    func getMainId() -> String {
        return ""
    }

    
    var url: String?
    var cfp : Cfp?
    
    func typeName() -> String {
        return entityName()
    }
    
    init(cfp : Cfp?, url: String?) {
        self.url = url ?? ""
        self.cfp = cfp
    }
    
    func feed(data: JSON) {
        url = data["href"].string
    }
    
    func entityName() -> String {
        return "Day"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        
        return json["links"].array
    }
    
    
       
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}
