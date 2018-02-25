//
//  TalkModel.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



public enum TalksStoreError: Equatable, Error {
    case cannotFetch(String)
}

public func ==(lhs: TalksStoreError, rhs: TalksStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotFetch(let a), .cannotFetch(let b)) where a == b: return true
    default: return false
    }
}


class TalkService : AbstractService {
    
    static let sharedInstance = TalkService()

    override init() {
        super.init()
    }
    
    
    func fetchTalksE<T>(_ criterion : T, searchPredicates : [String : [NSPredicate]]?, sortByDate : Bool, completionHandler: @escaping (_: NSFetchedResultsController<NSFetchRequestResult>?, _ error: TalksStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Talk")
                let sortTime = NSSortDescriptor(key: "slot.fromTime", ascending: true)
                let sortAlpha = NSSortDescriptor(key: "slot.roomName", ascending: true)
                let sortFavorite = NSSortDescriptor(key: "isFavorited", ascending: false)
                
                
                
                var sectionNameKeyPath:String
                var predicate:NSPredicate
                
                if sortByDate {
                    sectionNameKeyPath = "slot.fromTime"
                    predicate = NSPredicate(format: "slot.date = %@", criterion as! Date as CVarArg)
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
                DispatchQueue.main.async(execute: {
                    completionHandler(frc, nil)
                })
            } catch {
                DispatchQueue.main.async(execute: {
                    completionHandler(nil, TalksStoreError.cannotFetch("Cannot fetch talks"))
                })
                
            }
        }
    }
 
    
    func fetchTalksByDate(_ currentDate : Date, searchPredicates : [String : [NSPredicate]]?, completionHandler: @escaping (_: NSFetchedResultsController<NSFetchRequestResult>?, _ error: TalksStoreError?) -> Void) {
       
        fetchTalksE(currentDate, searchPredicates : searchPredicates, sortByDate : true, completionHandler : completionHandler)
        
        
    }
    
    func fetchTalksByTrackId(_ currentTrack : NSManagedObjectID, completionHandler: @escaping (_: NSFetchedResultsController<NSFetchRequestResult>?, _ error: TalksStoreError?) -> Void) {
        
        let attribute = self.privateManagedObjectContext.object(with: currentTrack) as! Attribute
        
        fetchTalksE(attribute.label!, searchPredicates : nil, sortByDate : false, completionHandler : completionHandler)
    }
    
    
    
    
    func setFavoriteStatus(_ fav:Bool, forTalkWithId talkId:String, completion : @escaping (_: CallbackProtocol) -> Void) {
        privateManagedObjectContext.perform {
            do {
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Talk")
                let predicate = NSPredicate(format: "id = %@", talkId)
                fetchRequest.predicate = predicate
                
                let items = try self.privateManagedObjectContext.fetch(fetchRequest)
                
                if items.count > 0 {
                    let talk = items[0] as! Talk
                    talk.isFavorited = fav
                    super.realSave(completion)
                }
                
            } catch {
                
            }
        }

    }
    
    func fetchTalks(_ ids : [NSManagedObjectID], completionHandler: @escaping (_: [DataHelperProtocol], _ error: TalksStoreError?) -> Void) {
        privateManagedObjectContext.perform {
            
        
            
            var talksArray = [DataHelperProtocol]()
            
            for singleId in ids {
                let obj = self.privateManagedObjectContext.object(with: singleId)
                
                if let objCast = obj as? HelperableProtocol {
                    talksArray.append(objCast.toHelper())
                }
                
            }
            
            DispatchQueue.main.async(execute: {
                completionHandler(talksArray, nil)
            })
        
        
        }
    }

    
    fileprivate func computePredicate(_ predicate : NSPredicate, searchPredicates : [String : [NSPredicate]]?) -> NSPredicate {

        var andPredicate = [NSPredicate]()
        andPredicate.append(predicate)
        var attributeOrPredicate = [NSPredicate]()
        
        if searchPredicates?.count > 0 {
            for name in searchPredicates!.keys {
                attributeOrPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: searchPredicates![name]!))
            }
        }
        
        andPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: attributeOrPredicate))
        andPredicate.append(NSPredicate(format: "title != %@", ""))
        return NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
    }
    
    func getTalkUrl(_ talkId : String) -> String {
        let cfp = self.privateManagedObjectContext.object(with: CfpService.sharedInstance.getCfp()) as! Cfp
        return "\(cfp.cfpEndpoint!)/conferences/\(cfp.id!)/talks/\(talkId)"
    }
    
        


}
