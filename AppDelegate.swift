//
//  AppDelegate.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import UIKit
import CoreData

//Fabric/CrashAnalytics
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func resourceReady(msg: CallbackProtocol) -> Void {
        //TODO
       
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Fabric.with([Crashlytics()])
        //Crashlytics.sharedInstance().debugMode = true
        
        //dunno why, first time UITextView is called, the UI freezes for about 1 sec, so by doing it here, the user wont be affected (workaround)
        UITextView()
        
        APIManager.firstFeed(resourceReady, service: StoredResourceService.sharedInstance)
        
        let color = ColorManager.topNavigationBarColor
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        UIPageControl.appearance().pageIndicatorTintColor = ColorManager.topNavigationBarColor
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.lightGrayColor()
        
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //self.window!.rootViewController = tabController
        
        let nav = ViewController()
        
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
        
               
        return true
    }
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.Portrait, .PortraitUpsideDown]
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.coreDataHelper.saveContext()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.coreDataHelper.saveContext()
    }
    
    lazy var mainManager: MainManager = {
        let mainManager = MainManager()
        return mainManager
    }()
    
    lazy var coreDataHelper: CoreDataHelper = {
        let coreDataHelper = CoreDataHelper()
        return coreDataHelper
    }()
    
 
    
    
}

