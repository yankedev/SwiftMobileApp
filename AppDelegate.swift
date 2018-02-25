//
//  AppDelegate.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

//Fabric/CrashAnalytics
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var session: WCSession?
    
    func resourceReady(_ msg: CallbackProtocol) -> Void {
        //TODO
       
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initWatchConnectivity()
        
        Fabric.with([Crashlytics.self])

        //Crashlytics.sharedInstance().debugMode = true
        
        //dunno why, first time UITextView is called, the UI freezes for about 1 sec, so by doing it here, the user wont be affected (workaround)
        let _ = UITextView()
        
        APIManager.firstFeed(resourceReady, service: StoredResourceService.sharedInstance)
        
        let color = ColorManager.topNavigationBarColor
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        UIPageControl.appearance().pageIndicatorTintColor = ColorManager.topNavigationBarColor
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.lightGray
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window!.rootViewController = tabController
        
        let nav = ViewController()
        
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
       
    
        return true
    }
    
    func t() {}
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.coreDataHelper.saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
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

extension AppDelegate: WCSessionDelegate {
    func initWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("to do")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("to do")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("to do")
    }

    
    func updateFavoriteStatus(_ favorite:Bool, forTalkWithId talkId:String, inConferenceWithId conferenceId:String) {
        if let session = session {
            let message = ["favorite":["value":favorite, "talkId":talkId, "conferenceId":conferenceId]]
            if session.isReachable {
                session.sendMessage(message, replyHandler: { (reply:[String : Any]) in
                    
                    }, errorHandler: { (error:Error) in
                        print(error)
                })
            } else {
                session.transferUserInfo(message)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        processMessage(message as [String : AnyObject])
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        processMessage(userInfo as [String : AnyObject])
    }
    
    fileprivate func processMessage(_ message:[String: AnyObject]) {
        if let favorite = message["favorite"] as? [String:AnyObject] {
            if let id = favorite["talkId"] as? String, let fav = (favorite["favorite"] as? NSNumber)?.boolValue {
                unscheduleLocalNotificationForTalkWithId(id)
                self.setFavoriteStatus(fav, forTalkWithId:id)
                if fav {
                    let title = favorite["title"] as? String
                    let room = favorite["room"] as? String
                    let fromTimeMillis = favorite["fromTimeMillis"] as? NSNumber
                    let fromTime = favorite["fromTime"] as? String
                    let toTime = favorite["toTime"] as? String
                    
                    scheduleLocalNotificationForTalkWithId(id, title: title!, room: room!, fromTime: fromTime!, toTime: toTime!, fromTimeMillis: fromTimeMillis!)
                }
            }
        }
    }
    
    fileprivate func setFavoriteStatus(_ fav:Bool, forTalkWithId talkId:String) {
        TalkService.sharedInstance.setFavoriteStatus(fav, forTalkWithId: talkId, completion : sendNotif)
    }
    
    
    
    fileprivate func sendNotif(_ msg : CallbackProtocol) {
        if msg.getMessage() == "OK" {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateFavorite"), object: nil)
        }
    }
    
    func scheduleLocalNotificationForTalkWithId(_ id:String, title:String, room:String, fromTime:String, toTime:String, fromTimeMillis:NSNumber){
        let date = Date(timeIntervalSince1970: fromTimeMillis.doubleValue / 1000)
        let notification = UILocalNotification()
        notification.fireDate = date.addingTimeInterval(-10*60)
        notification.timeZone = TimeZone.autoupdatingCurrent
        notification.userInfo = [
            "id": id,
            "title":title,
            "room":room,
            "fromTimeMillis":fromTimeMillis,
            "fromTime":fromTime,
            "toTime":toTime
        ]
        notification.alertTitle = title
        notification.alertBody = String(format: NSLocalizedString("From %@ to %@ in %@", comment: ""), arguments: [fromTime, toTime, room])
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func unscheduleLocalNotificationForTalkWithId(_ id:String) {
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            if let userInfo = notification.userInfo {
                if let talkId = userInfo["id"] as? String {
                    if talkId == id {
                        UIApplication.shared.cancelLocalNotification(notification)
                    }
                }
            }
        }
    }
}

