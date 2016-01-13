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


class Attribute: NSManagedObject, FeedableProtocol, FilterableProtocol {
    
    @NSManaged var id: String?
    @NSManaged var label: String?
    @NSManaged var attributeDescription: String?
    @NSManaged var type: String?
    
    
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
            return "talk.trackId"
        }
        return "talk.talkType"
    }
    
    func filterPredicateRightValue() -> String {
        if(type == "Track") {
            return id!
        }
        return label!
    }
    
    func filterMiniIcon() -> UIImage {
        return UIImage(named: "icon_\(id!)")!
    }
    
    func niceLabel() -> String {
        if(type == "Track") {
            return "By track"
        }
        return "By type"
    }
    
    func exists(id : String, leftPredicate: String, entity: String) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "\(leftPredicate) = %@", id)
        fetchRequest.predicate = predicate
        let items = try! context.executeFetchRequest(fetchRequest)
        return items.count > 0
    }

}
