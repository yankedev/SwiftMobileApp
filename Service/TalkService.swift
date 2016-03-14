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


class TalkService : AbstractService {
    
    static let sharedInstance = TalkService()

    override init() {
        super.init()
    }
    
    func fetchTalksByDate(currentDate : NSDate, searchPredicates : [String : [NSPredicate]]?, completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        fetchTalks(currentDate, searchPredicates : searchPredicates, sortByDate : true, completionHandler : completionHandler)
    }
    
    func fetchTalksByTrackId(currentTrack : NSManagedObjectID, completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        
        let attribute = self.privateManagedObjectContext.objectWithID(currentTrack) as! Attribute

        fetchTalks(attribute.label!, searchPredicates : nil, sortByDate : false, completionHandler : completionHandler)
    }
    
    func fetchTalks<T>(criterion : T, searchPredicates : [String : [NSPredicate]]?, sortByDate : Bool, completionHandler: (talks: NSFetchedResultsController?, error: TalksStoreError?) -> Void) {
        privateManagedObjectContext.performBlock {
            do {
                let fetchRequest = NSFetchRequest(entityName: "Talk")
                let sortTime = NSSortDescriptor(key: "slot.fromTime", ascending: true)
                let sortAlpha = NSSortDescriptor(key: "title", ascending: true)
                let sortFavorite = NSSortDescriptor(key: "isFavorited", ascending: false)
                
                
                
                var sectionNameKeyPath:String
                var predicate:NSPredicate
                
                if sortByDate {
                    sectionNameKeyPath = "slot.fromTime"
                    predicate = NSPredicate(format: "slot.date = %@", criterion as! CVarArgType)
                    fetchRequest.sortDescriptors = [sortTime, sortFavorite, sortAlpha]
                }
                else {
                    sectionNameKeyPath = "track"
                    predicate = NSPredicate(format: "track = %@", criterion as! String)
                    fetchRequest.sortDescriptors = [sortFavorite, sortAlpha]
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
    
    private func computePredicate(predicate : NSPredicate, searchPredicates : [String : [NSPredicate]]?) -> NSPredicate {
        
        
        
        var andPredicate = [NSPredicate]()
        let predicateEvent = NSPredicate(format: "slot.cfp.country = %@", super.getCfpId())
        
        andPredicate.append(predicate)
        //andPredicate.append(predicateEvent)
        
        var attributeOrPredicate = [NSPredicate]()
        
        if searchPredicates?.count > 0 {
            for name in searchPredicates!.keys {
                attributeOrPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: searchPredicates![name]!))
            }
        }
        
        andPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: attributeOrPredicate))
        return NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
    }

}