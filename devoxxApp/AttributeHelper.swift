//
//  AttributeHelper.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

public class AttributeHelper: DataHelper {
    
    public var id: String
    public var label: String
    public var attributeDescription: String
    public var type:String

    init(id: String?, label: String?, attributeDescription: String?, type: String?) {
        self.id = id ?? ""
        self.label = label ?? ""
        self.attributeDescription = attributeDescription ?? ""
        self.type = type ?? ""
    }
    
    override public var description: String {
        return "id: \(id)\n label: \(label)\n attributeDescription: \(attributeDescription)\n type: \(type)\n"
    }
    
    override public class func save(dataHelper : DataHelper) -> Void {
        print("attribute")
        super.save(dataHelper)
    }
    
}
