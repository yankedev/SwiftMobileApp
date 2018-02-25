//
//  DataController.swift
//  Smartvoxx
//
//  Created by Sebastien Arbogast on 26/10/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import UIKit

class DataController: NSObject {
    static let flatUiColors = ["#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#34495e", "#f1c40f", "#e67e22", "#e74c3c", "#ecf0f1", "#95a5a6", "#16a085", "#27ae60", "#2980b9", "#8e44ad", "#2c3e50", "#f39c12", "#d35400", "#c0392b", "#bdc3c7", "#7f8c8d"]
    
    static var sharedInstance = DataController()
    
    fileprivate var session:URLSession
    fileprivate var cache:DevoxxCache
    
    fileprivate var conferencesTask:URLSessionDataTask?
    fileprivate var schedulesTask:URLSessionDataTask?
    fileprivate var slotsTasks = [String:URLSessionDataTask]()
    fileprivate var speakerTasks = [String:URLSessionDataTask]()
    fileprivate var avatarTasks = [String:URLSessionDataTask]()
    
    fileprivate override init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: configuration)
        
        cache = DevoxxCache()
    }
    
    fileprivate func cancelTask(_ task: URLSessionDataTask?) {
        if let task = task {
            if task.state == URLSessionTask.State.running {
                task.cancel()
            }
        }
    }
    
    func getConferences(_ callback:@escaping (([Conference]) -> Void)) {
        let conferences = cache.getConferences()
        if conferences.count > 0 {
            DispatchQueue.main.async(execute: { 
                callback(conferences)
            })
        }
        
        let cfpUrl = Bundle.main.infoDictionary!["CFP_URL"] as! String
        let url = URL(string: cfpUrl)!
        self.conferencesTask = self.session.dataTask(with: url, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) in
            guard let data = data else {
                print(error)
                return
            }
            
            self.cache.saveConferencesFromData(data)
            DispatchQueue.main.async(execute: { 
                callback(self.cache.getConferences())
            })
        } as! (Data?, URLResponse?, Error?) -> Void) 
        self.conferencesTask?.resume()
    }
    
    func cancelConferences() {
        self.cancelTask(self.conferencesTask)
    }
    
    func getSchedulesForConference(_ conference: Conference, callback:@escaping (([Schedule]) -> Void)) {
        guard let conferenceId = conference.conferenceId else {
            DispatchQueue.main.async(execute: { 
                callback([Schedule]())
            })
            return
        }
        let schedules = cache.getSchedulesForConferenceWithId(conferenceId)
        if schedules.count > 0 {
            DispatchQueue.main.async(execute: { () -> Void in
                callback(schedules)
            })
        }
        
        let schedulesUrl = "\(conference.cfpEndpointUrl!)/conferences/\(conferenceId)/schedules/"
        let url = (URL(string: schedulesUrl))!
        self.schedulesTask = self.session.dataTask(with: url, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            
            guard let data = data else {
                print(error)
                return
            }
            self.cache.saveSchedulesFromData(data, forConferenceWithId: conferenceId)
            DispatchQueue.main.async(execute: { () -> Void in
                callback(self.cache.getSchedulesForConferenceWithId(conferenceId))
            })
        } as! (Data?, URLResponse?, Error?) -> Void) 
        self.schedulesTask?.resume()
    }
    
    func cancelSchedules() {
        cancelTask(self.schedulesTask)
    }
    
    func getSlotsForSchedule(_ schedule:Schedule, callback:@escaping (([Slot]) -> Void)) {
        let slots = cache.getSlotsForScheduleWithHref(schedule.href!)
        if slots.count > 0 {
            DispatchQueue.main.async(execute: { () -> Void in
                callback(slots)
            })
        }
        
        let url = URL(string: schedule.href!)!
        let task = self.session.dataTask(with: url, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            
            guard let data = data else {
                print(error)
                return
            }
            self.cache.saveSlotsFromData(data, forScheduleWithHref:schedule.href!)
            DispatchQueue.main.async(execute: { () -> Void in
                callback(self.cache.getSlotsForScheduleWithHref(schedule.href!))
            })
        } as! (Data?, URLResponse?, Error?) -> Void) 
        self.slotsTasks[schedule.href!] = task
        task.resume()
    }
    
    func cancelSlotsForSchedule(_ schedule:Schedule) {
        if let href = schedule.href, let task = self.slotsTasks[href] {
            self.cancelTask(task)
        }
    }
    
    func swapFavoriteStatusForTalkSlot(_ talkSlot:TalkSlot, callback:@escaping ((TalkSlot) -> Void)){
        cache.swapFavoriteStatusForTalkSlotWithTalkId(talkSlot.talkId!)
        DispatchQueue.main.async { () -> Void in
            if let talkSlot = self.cache.getTalkSlotWithTalkId(talkSlot.talkId!) {
                DispatchQueue.main.async(execute: { () -> Void in
                    callback(talkSlot)
                })
            }
        }
    }

    func getSpeaker(_ speaker:Speaker, callback:@escaping ((Speaker) -> Void)){
        if let speaker = cache.getSpeakerWithHref(speaker.href!), let _ = speaker.firstName {
            DispatchQueue.main.async(execute: { () -> Void in
                callback(speaker)
            })
        }
        
        let url = URL(string: speaker.href!)!
        let task = self.session.dataTask(with: url, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            guard let data = data else {
                print(error)
                return
            }
            
            self.cache.saveSpeakerFromData(data, forSpeakerWithHref:speaker.href!)
            DispatchQueue.main.async(execute: { () -> Void in
                if let speaker = self.cache.getSpeakerWithHref(speaker.href!) {
                    callback(speaker)
                }
            })
        } as! (Data?, URLResponse?, Error?) -> Void)
        self.speakerTasks[speaker.href!] = task
        task.resume()
    }
    
    func cancelSpeaker(_ speaker:Speaker){
        if let task = self.speakerTasks[speaker.href!] {
            self.cancelTask(task)
        }
    }
    
    func getAvatarForSpeaker(_ speaker:Speaker, callback:@escaping ((Data) -> Void)) {
        if let speaker = cache.getSpeakerWithHref(speaker.href!), let avatar = speaker.avatar, avatar.count > 0 {
            DispatchQueue.main.async(execute: { () -> Void in
                callback(avatar)
            })
        }
        
        let url = URL(string: speaker.avatarURL!)!
        let task = self.session.dataTask(with: url, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            guard let data = data, data.count > 0 else {
                print(error)
                return
            }
            
            self.cache.saveAvatarFromData(data, forSpeakerWithHref:speaker.href!)
            DispatchQueue.main.async(execute: { () -> Void in
                if let avatarData = self.cache.getAvatarForSpeakerWithHref(speaker.href!) {
                    callback(avatarData)
                }
            })
        } as! (Data?, URLResponse?, Error?) -> Void)
        self.avatarTasks[speaker.avatarURL!] = task
        task.resume()
    }
    
    func cancelAvatarForSpeaker(_ speaker:Speaker){
        if let task = self.avatarTasks[speaker.href!] {
            self.cancelTask(task)
        }
    }
    
    func getFavoriteTalksAfterDate(_ date: Date) -> [TalkSlot] {
        return cache.getFavoriteTalksAfterDate(date)
    }
    
    func getFavoriteTalksBeforeDate(_ date: Date) -> [TalkSlot] {
        return cache.getFavoriteTalksBeforeDate(date)
    }
    
    func getFirstTalk() -> TalkSlot? {
        return cache.getFirstTalk()
    }
    
    func getLastTalk() -> TalkSlot? {
        return cache.getLastTalk()
    }
    
    func setFavorite(_ favorite:Bool, forTalkWithId talkId:String, inConferenceWithId conferenceId:String, callback:@escaping ((TalkSlot) -> Void)) {
        cache.setFavorite(favorite, forTalkSlotWithId: talkId)
        DispatchQueue.main.async {
            if let modifiedSlot = self.cache.getTalkSlotWithTalkId(talkId) {
                callback(modifiedSlot)
            }
        }
    }
}
