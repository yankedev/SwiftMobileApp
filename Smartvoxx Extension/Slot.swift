//
//  Slot.swift
//  Smartvoxx
//
//  Created by Sebastien Arbogast on 04/10/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import Foundation
import CoreData

class Slot: NSManagedObject {
    var timeRange:String {
        return "\(self.fromTime!) - \(self.toTime!)"
    }
}
