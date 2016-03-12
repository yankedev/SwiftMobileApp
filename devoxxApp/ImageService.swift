//
//  ImageService.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class ImageService : AbstractService {
    
    override init() {
        super.init()
    }
    
    
   
    func updateImageForId(id : NSManagedObjectID, withData data: NSData, completionHandler : (msg: String) -> Void) {
        
        privateManagedObjectContext.performBlock {
            
            do {
                if let obj:ImageFeedable = APIDataManager.findEntityFromId(id, inContext: self.privateManagedObjectContext) {
                    obj.feedImageData(data)
                   
                    super.realSave()
                    dispatch_async(dispatch_get_main_queue(),{
                        completionHandler(msg: "ok")
                    })
                }
            } catch {
                completionHandler(msg : "KO")
            }
            
            
            

            
            
        }
        
    }

    
        
        
}