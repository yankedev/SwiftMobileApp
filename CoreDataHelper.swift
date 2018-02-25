//
//  CoreDataHelper.swift
//  My_Devoxx
//
//  Created by Maxime on 16/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper: NSObject{
    
    let mainManager: MainManager!
    
    override init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.mainManager = appDelegate.mainManager
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var mainThreadContext: NSManagedObjectContext = {
        let coordinator = self.mainManager.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var backgroundThreadContext: NSManagedObjectContext? = {
        let coordinator = self.mainManager.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    
    
    func saveContext (_ context: NSManagedObjectContext) {
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch let error1 as NSError {
                error = error1
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func saveContext () {
        self.saveContext( self.backgroundThreadContext! )
    }
    

    func contextDidSaveContext(_ notification: Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.mainThreadContext {
            self.backgroundThreadContext!.perform {
                self.backgroundThreadContext!.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === self.backgroundThreadContext {
            self.mainThreadContext.perform {
                self.mainThreadContext.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            self.backgroundThreadContext!.perform {
                self.backgroundThreadContext!.mergeChanges(fromContextDidSave: notification)
            }
            self.mainThreadContext.perform {
                self.mainThreadContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}
