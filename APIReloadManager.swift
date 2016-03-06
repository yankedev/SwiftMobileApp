//
//  APIReloadManager.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class APIReloadManager {
    
    
    class func run_on_background_thread(code: () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    
    class func fetchUpdate(url : String, helper : DataHelperProtocol, completedAction : () -> Void) {
        print("I will try to update : \(url)")
        run_on_background_thread {
            sleep(3)
            completedAction()
        }
        
    }

}