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
    
    public class func fileName() -> String {
        return entityName()
    }
    
    public class func prepareArray(json : JSON) -> [JSON]? {
        return nil
    }
    
    public class func save(dataHelper : DataHelper) -> Void {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName(entityName(), inManagedObjectContext: managedContext)
        let coreDataObject = Feedable(entity: entity!, insertIntoManagedObjectContext: managedContext)
        coreDataObject.feed(dataHelper)
        generateFavorite(managedContext, object:coreDataObject, type: entityName())
        saveCoreData(managedContext)
    }
    
    public class func saveCoreData(context:NSManagedObjectContext) {
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    class func generateFavorite(managedContext:NSManagedObjectContext, object: Feedable, type: String) {
        if let favoritableEntity = object as? FavoriteProtocol {
            let favEntity = NSEntityDescription.entityForName("Favorite", inManagedObjectContext: managedContext)
            let favCoreData = devoxxApp.Favorite(entity: favEntity!, insertIntoManagedObjectContext: managedContext)
            favCoreData.id = favoritableEntity.getIdentifier()
            favCoreData.isFavorited = 0
            favCoreData.type = type
        }
    }

}
