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
    
    func save(managedContext : NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if let coreDataObjectCast = coreDataObject as? FeedableProtocol {
            print("ok feedable protocol")
            coreDataObjectCast.feedHelper(self)
            if(coreDataObjectCast.exists(imgName!, leftPredicate:"img", entity: entityName())) {
                print("img already exists")
                return
            }
        }
        else {
            print("img KO")
        }
        print("save IT")
        print(coreDataObject)
        APIManager.save(managedContext)
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
}