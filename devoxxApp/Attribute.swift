//
//  Attribute.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Unbox


class Attribute: NSManagedObject, Unboxable, FeedableProtocol, FilterableProtocol {
    
    @NSManaged var id: String?
    @NSManaged var label: String?
    @NSManaged var attributeDescription: String?
    @NSManaged var type: String?
    @NSManaged var cfp: Cfp?
    
    convenience init() {
        let context = AttributeService.sharedInstance.privateManagedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Attribute", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }
    
    convenience internal required init(unboxer: Unboxer) {
        self.init()
        self.id = unboxer.unbox("id")
        self.label = unboxer.unbox("title")
        self.attributeDescription = unboxer.unbox("description")
        self.type = "track"
    }
    
    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? AttributeHelper  {
            id = castHelper.id
            label = castHelper.label
            attributeDescription = castHelper.attributeDescription
            type = castHelper.type
        }
    }
    
    func filterPredicateLeftValue() -> String {
        if(type == "Track") {
            return "trackId"
        }
        return "talkType"
    }
    
    func filterPredicateRightValue() -> String {
        if(type == "Track") {
            return id!
        }
        return label!
    }
    
    func filterMiniIcon() -> UIImage? {
        return UIImage(named: "icon_\(id!)")
    }
    
    func niceLabel() -> String {
        if(type == "Track") {
            return "By track"
        }
        return "By type"
    }
    
    func getId() -> NSManagedObject? {
        return nil
    }
    
    func resetId(id: NSManagedObject?) {
    }
    
    func service() -> AbstractService {
        return AttributeService.sharedInstance
    }
    
    
}
