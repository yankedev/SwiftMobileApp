//
//  Day.swift
//  devoxxApp
//
//  Created by maxday on 02.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Day: NSManagedObject, FeedableProtocol {
    
    @NSManaged var url: String
    @NSManaged var cfp: Cfp
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? DayHelper  {
            url = castHelper.url ?? ""
            cfp = castHelper.cfp!
        }
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    
    func resetId(id: NSManagedObject?) {
    }
    
    
}

