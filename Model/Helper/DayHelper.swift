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
    
    var url: String?
    var cfp : Cfp?
    
    init () {
    }
    
    init(cfp : Cfp?, url: String?) {
        self.url = url ?? ""
        self.cfp = cfp
    }
    
    func getMainId() -> String {
        return url!
    }
    
    func typeName() -> String {
        return entityName()
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
    
}
