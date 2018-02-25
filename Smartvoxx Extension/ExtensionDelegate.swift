//
//  ExtensionDelegate.swift
//  Smartvoxx Extension
//
//  Created by Sebastien Arbogast on 09/04/2016.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    fileprivate var session:WCSession?

    func applicationDidFinishLaunching() {
        initWatchConnectivity()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}

extension ExtensionDelegate:WCSessionDelegate {
    func initWatchConnectivity() {
        if WCSession.isSupported() {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("OK")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        processMessage(message as [String : AnyObject])
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        processMessage(userInfo as [String : AnyObject])
    }
    
    fileprivate func processMessage(_ message:[String:AnyObject]) {
        if let favorite = message["favorite"] as? [String:AnyObject] {
            if let value = favorite["value"] as? Bool, let talkId = favorite["talkId"] as? String, let conferenceId = favorite["conferenceId"] as? String {
                DataController.sharedInstance.setFavorite(value, forTalkWithId:talkId, inConferenceWithId:conferenceId) { (talkSlot:TalkSlot) in
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "talkFavoriteStatusChanged"), object: nil, userInfo: ["talkSlot":talkSlot])
                }
            }
        }
    }
    
    func updateFavoriteStatusForTalkSlot(_ talkSlot:TalkSlot) {
         let talkSlotMessage = [
            "title":talkSlot.title!,
            "room":talkSlot.roomName!,
            "talkId":talkSlot.talkId!,
            "conferenceId":talkSlot.schedule!.conference!.conferenceId!,
            "track":talkSlot.track!.name!,
            "favorite":talkSlot.favorite!,
            "fromTimeMillis":talkSlot.fromTimeMillis!,
            "fromTime":talkSlot.fromTime!,
            "toTime":talkSlot.toTime!
         ] as [String : Any]
         
         if let session = self.session, session.isReachable {
            session.sendMessage(["favorite" : talkSlotMessage], replyHandler: { (reply:[String : Any]) -> Void in
         
                }, errorHandler: { (error:Error) -> Void in
                    print(error)
            })
         } else {
            session?.transferUserInfo(["favorite" : talkSlotMessage as NSDictionary])
         }
    }
}
