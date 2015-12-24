//
//  DataHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public class DataHelper: NSObject {
    
    public class func feed(data: JSON) -> DataHelper? {
        return nil
    }
    
    public class func entityName() -> String {
        return ""
    }
    
    public class func correspondingType() -> NSManagedObject.Type? {
        return nil
    }
    
    public class func prepareArray(json : JSON) -> [JSON]? {
        return nil
    }
}
