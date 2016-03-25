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
    
   
    var privateManagedObjectContext: NSManagedObjectContext

    var currentCfp:Cfp?
  
    init() {
       
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        privateManagedObjectContext = appDelegate.coreDataHelper.backgroundThreadContext!
        
    }
    
    func invertFavorite(id : NSManagedObjectID) -> Bool {
        if let cellData:FavoriteProtocol = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
            cellData.invertFavorite()
            //TODO
            self.realSave(nil)
            return cellData.isFav()
        }
        return false
    }
    
    
    func realSave(completionHandler : ((msg: CallbackProtocol) -> Void)?) {
        return realSave(completionHandler, obj : nil, img : nil)
    }
    
    func realSave(completionHandler : ((msg: CallbackProtocol) -> Void)?, obj : DataHelperProtocol?) {
        return realSave(completionHandler, obj : obj, img : nil)
    }
    
    func realSave(completionHandler : ((msg: CallbackProtocol) -> Void)?, img : NSData?) {
        return realSave(completionHandler, obj : nil, img : img)
    }
    
    func realSave(completionHandler : ((msg: CallbackProtocol) -> Void)?, obj :DataHelperProtocol?, img : NSData?) {

        
        do {
            try privateManagedObjectContext.save()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.coreDataHelper.mainThreadContext.performBlock {
                do {
                    try appDelegate.coreDataHelper.mainThreadContext.save()
                    
                        if obj != nil {
                            completionHandler?(msg: CompletionMessage(obj : obj!))
                        }
                        else if img != nil {
                            completionHandler?(msg: CompletionMessage(img : img))
                        }
                        else {
                            completionHandler?(msg: CompletionMessage(msg: "OK"))
                            
                        }
                        
                    
                } catch let err as NSError {
                    //print("Could not save main context: \(err.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler?(msg: CompletionMessage(msg: "KO"))
                    })
                }
            }
        } catch let err as NSError {
            //print("Could not save private context: \(err.localizedDescription)")
            dispatch_async(dispatch_get_main_queue(),{
                completionHandler?(msg: CompletionMessage(msg: "KO"))
            })
        }
    }

    func saveImage(completionHandler : ((data: NSData?) -> NSData)?) {
        do {
            try privateManagedObjectContext.save()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.coreDataHelper.mainThreadContext.performBlock {
                do {
                    try appDelegate.coreDataHelper.mainThreadContext.save()
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler?(data: nil)
                    })
                } catch let err as NSError {
                    //print("Could not save main context: \(err.localizedDescription)")
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler
                    })
                }
            }
        } catch let err as NSError {
            //print("Could not save private context: \(err.localizedDescription)")
            dispatch_async(dispatch_get_main_queue(),{
                completionHandler
            })
        }
    }

    
    func getHelper() -> DataHelperProtocol {
        return SpeakerHelper()
    }
    
    func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        
    }
    
    func getCfpId() -> String{
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentEventStr = defaults.objectForKey("currentEvent") as? String {
            return currentEventStr
        }
        return ""
    }
    
    
    func isEmpty() -> Bool {
        return true
    }
    
    func hasBeenAlreadyFed() -> Bool {
        return false
    }
    
    
        
   

}
