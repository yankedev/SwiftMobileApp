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
    
    
    func fetchTalksByDate(currentDate : NSDate, searchPredicates : [String : [NSPredicate]]?, completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        fetchTalks(currentDate, searchPredicates : searchPredicates, sortByDate : true, completionHandler : completionHandler)
    }
    
    func fetchTalksByTrack(currentTrack : String, completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        fetchTalks(currentTrack, searchPredicates : nil, sortByDate : false, completionHandler : completionHandler)
    }
    
    
    func fetchTalks<T>(criterion : T, searchPredicates : [String : [NSPredicate]]?, sortByDate : Bool, completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                let fetchRequest = NSFetchRequest(entityName: "Talk")
                let sortTime = NSSortDescriptor(key: "slot.fromTime", ascending: true)
                let sortAlpha = NSSortDescriptor(key: "title", ascending: true)
                let sortFavorite = NSSortDescriptor(key: "isFavorited", ascending: false)
                
                fetchRequest.sortDescriptors = [sortTime, sortFavorite, sortAlpha]
                fetchRequest.fetchBatchSize = 20
                fetchRequest.returnsObjectsAsFaults = false
                
                
                var sectionNameKeyPath:String
                var predicate:NSPredicate
                
                if sortByDate {
                    sectionNameKeyPath = "slot.fromTime"
                    predicate = NSPredicate(format: "slot.date = %@", criterion as! CVarArgType)
                }
                else {
                    sectionNameKeyPath = "track"
                    predicate = NSPredicate(format: "track = %@", criterion as! String)
                }
                
                fetchRequest.predicate = self.computePredicate(predicate, searchPredicates: searchPredicates)
                
                let frc = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: self.privateManagedObjectContext,
                    sectionNameKeyPath: sectionNameKeyPath,
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
    
    func invertFavorite(id : NSManagedObjectID) -> Bool {
        if let cellData:FavoriteProtocol = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
            cellData.invertFavorite()
            APIManager.save(self.privateManagedObjectContext)
            return cellData.isFav()
        }
        return false
    }
    
    private func computePredicate(predicate : NSPredicate, searchPredicates : [String : [NSPredicate]]?) -> NSPredicate {
        
        let currentCfp:Cfp? = APIDataManager.findEntityFromId(APIManager.currentEvent.objectID, inContext: self.privateManagedObjectContext)
        
        
        var andPredicate = [NSPredicate]()
        let predicateEvent = NSPredicate(format: "slot.cfp = %@", currentCfp!)
        
        andPredicate.append(predicate)
        andPredicate.append(predicateEvent)
        
        var attributeOrPredicate = [NSPredicate]()
        
        if searchPredicates?.count > 0 {
            for name in searchPredicates!.keys {
                attributeOrPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: searchPredicates![name]!))
            }
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