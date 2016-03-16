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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.mainManager = appDelegate.mainManager
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    lazy var mainThreadContext: NSManagedObjectContext = {
        let coordinator = self.mainManager.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var backgroundThreadContext: NSManagedObjectContext? = {
        let coordinator = self.mainManager.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    
    
    func saveContext (context: NSManagedObjectContext) {
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
    

    func contextDidSaveContext(notification: NSNotification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.mainThreadContext {
            self.backgroundThreadContext!.performBlock {
                self.backgroundThreadContext!.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else if sender === self.backgroundThreadContext {
            self.mainThreadContext.performBlock {
                self.mainThreadContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else {
            self.backgroundThreadContext!.performBlock {
                self.backgroundThreadContext!.mergeChangesFromContextDidSaveNotification(notification)
            }
            self.mainThreadContext.performBlock {
                self.mainThreadContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
}