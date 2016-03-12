//
//  TalkModel.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData


public enum TalksStoreError: Equatable, ErrorType {
    case CannotFetch(String)
}

public func ==(lhs: TalksStoreError, rhs: TalksStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class TalkService {

    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    
    func fetchTalksByDate(currentDate : NSDate, searchPredicates : [String : [NSPredicate]], completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                let fetchRequest = NSFetchRequest(entityName: "Talk")
                let sortTime = NSSortDescriptor(key: "slot.fromTime", ascending: true)
                let sortAlpha = NSSortDescriptor(key: "title", ascending: true)
                let sortFavorite = NSSortDescriptor(key: "isFavorited", ascending: true)
                
                fetchRequest.sortDescriptors = [sortTime, sortAlpha, sortFavorite]
                fetchRequest.fetchBatchSize = 20
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.predicate = self.computePredicate(currentDate, searchPredicates: searchPredicates)
                
                let frc = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: self.privateManagedObjectContext,
                    sectionNameKeyPath: "slot.fromTime",
                    cacheName: nil)
                
                
                try frc.performFetch()
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(talks: frc, error: nil)
                })
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(talks: nil, error: TalksStoreError.CannotFetch("Cannot fetch talks"))
                })
               
            }
        }
    }
    
    private func computePredicate(currentDate : NSDate, searchPredicates : [String : [NSPredicate]]) -> NSPredicate {
        
        let currentCfp:Cfp? = APIDataManager.findEntityFromId(APIManager.currentEvent.objectID, inContext: self.privateManagedObjectContext)
        
        
        var andPredicate = [NSPredicate]()
        let predicateDay = NSPredicate(format: "slot.date = %@", currentDate)
        let predicateEvent = NSPredicate(format: "slot.cfp = %@", currentCfp!)
        
        andPredicate.append(predicateDay)
        andPredicate.append(predicateEvent)
        
        var attributeOrPredicate = [NSPredicate]()
        
        for name in searchPredicates.keys {
            attributeOrPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: searchPredicates[name]!))
        }
        
        andPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: attributeOrPredicate))
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
    }

    
    
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
    
    
  
    
}