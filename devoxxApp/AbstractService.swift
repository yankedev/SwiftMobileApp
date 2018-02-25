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
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        privateManagedObjectContext = appDelegate.coreDataHelper.backgroundThreadContext!
        
    }
    
    func invertFavorite(_ id : NSManagedObjectID) -> Bool {
        if let cellData:FavoriteProtocol = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
            cellData.invertFavorite()
            //TODO
            self.realSave(nil)
            return cellData.isFav()
        }
        return false
    }
    
    
    func realSave(_ completionHandler : ((_ msg: CallbackProtocol) -> Void)?) {
        return realSave(completionHandler, obj : nil, img : nil)
    }
    
    func realSave(_ completionHandler : ((_ msg: CallbackProtocol) -> Void)?, obj : DataHelperProtocol?) {
        return realSave(completionHandler, obj : obj, img : nil)
    }
    
    func realSave(_ completionHandler : ((_ msg: CallbackProtocol) -> Void)?, img : Data?) {
        return realSave(completionHandler, obj : nil, img : img)
    }
    
    func realSave(_ completionHandler : ((_ msg: CallbackProtocol) -> Void)?, obj :DataHelperProtocol?, img : Data?) {

        
        do {
            try privateManagedObjectContext.save()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.coreDataHelper.mainThreadContext.perform {
                do {
                    try appDelegate.coreDataHelper.mainThreadContext.save()
                    
                        if obj != nil {
                            completionHandler?(CompletionMessage(obj : obj!))
                        }
                        else if img != nil {
                            completionHandler?(CompletionMessage(img : img as! NSData as Data))
                        }
                        else {
                            completionHandler?(CompletionMessage(msg: "OK"))
                            
                        }
                        
                    
                } catch _ as NSError {
                    //print("Could not save main context: \(err.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                        completionHandler?(CompletionMessage(msg: "KO"))
                    })
                }
            }
        } catch _ as NSError {
            //print("Could not save private context: \(err.localizedDescription)")
            DispatchQueue.main.async(execute: {
                completionHandler?(CompletionMessage(msg: "KO"))
            })
        }
    }

    func saveImage(_ completionHandler : ((_ data: Data?) -> Data)?) {
        do {
            try privateManagedObjectContext.save()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.coreDataHelper.mainThreadContext.perform {
                do {
                    try appDelegate.coreDataHelper.mainThreadContext.save()
                    DispatchQueue.main.async(execute: {
                        completionHandler?(nil)
                    })
                } catch _ as NSError {
                    //print("Could not save main context: \(err.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                        completionHandler
                    })
                }
            }
        } catch _ as NSError {
            //print("Could not save private context: \(err.localizedDescription)")
            DispatchQueue.main.async(execute: {
                completionHandler
            })
        }
    }

    
    func getHelper() -> DataHelperProtocol {
        return SpeakerHelper()
    }
    
    func updateWithHelper(_ helper : [DataHelperProtocol], completionHandler : @escaping (_ msg: CallbackProtocol) -> Void) {
        
    }
    
    func getCfpId() -> String{
        let defaults = UserDefaults.standard
        if let currentEventStr = defaults.object(forKey: "currentEvent") as? String {
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
