//
//  AbstractService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AbstractService  {
    
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext

   
    
    var currentCfp:Cfp?
  
    init() {
       
        mainManagedObjectContext = MainManager.sharedInstance.mainManagedObjectContext

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
    
    func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        
    }
    
    func getCfpId() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentEventStr = defaults.objectForKey("currentEvent") as? String {
            print("READIND 0 \(currentEventStr)")
            return currentEventStr
        }
        return ""
    }
    
    
    func isEmpty() -> Bool {
        return true
    }
    
    
        
   

}
