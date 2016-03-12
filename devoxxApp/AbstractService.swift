//
//  AbstractService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class AbstractService  {
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext

    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("My_Devoxx", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
        This code uses a file named "DataModel.sqlite" in the application's documents directory.
        */
        let storeURL = docURL.URLByAppendingPathComponent("devoxxApp.sqlite")
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateManagedObjectContext.parentContext = mainManagedObjectContext
    }
    
    func invertFavorite(id : NSManagedObjectID) -> Bool {
        if let cellData:FavoriteProtocol = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
            cellData.invertFavorite()
            self.realSave(nil)
            return cellData.isFav()
        }
        return false
    }
    
    func realSave(completionHandler : ((msg: String) -> Void)?) {
        do {
            try privateManagedObjectContext.save()
            mainManagedObjectContext.performBlock {
                do {
                    try self.mainManagedObjectContext.save()
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler?(msg: "ok")
                    })
                } catch let err as NSError {
                    print("Could not save main context: \(err.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler?(msg: "ko")
                    })
                }
            }
        } catch let err as NSError {
            print("Could not save private context: \(err.localizedDescription)")
            dispatch_async(dispatch_get_main_queue(),{
                completionHandler?(msg: "ko")
            })
        }
    }

    func getHelper() -> DataHelperProtocol {
        return SpeakerHelper()
    }
    
    func updateWithHelper(helper : DataHelperProtocol, completionHandler : (msg: String) -> Void) {
        print("HERE")
    }
    
    func getCfpId() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentEventStr = defaults.objectForKey("currentEvent") as? String {
            return currentEventStr
        }
        return ""
    }

}
