//
//  DevoxxCache.swift
//  Smartvoxx
//
//  Created by Sebastien Arbogast on 26/10/2015.
//  Copyright © 2015 Epseelon. All rights reserved.
//

import CoreData

class DevoxxCache: NSObject {
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModel(from: nil)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Smartvoxx.sqlite")
        do {
            print(url)
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print(error)
        }
        
        return coordinator
    }()
    
    lazy var mainObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var privateObjectContext: NSManagedObjectContext = {
        var privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self.mainObjectContext
        return privateContext
    }()
    
    override init() {
        
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            if let parentContext = context.parent {
                try parentContext.save()
            }
        } catch {
            print(error)
            abort()
        }
    }
    
    func getConferences() -> [Conference] {
        return self.getConferences(fromContext: self.mainObjectContext)
    }
    
    func saveConferencesFromData(_ data:Data) {
        self.saveConferencesFromData(data, inContext:self.privateObjectContext)
    }
    
    fileprivate func getConferences(fromContext context:NSManagedObjectContext) -> [Conference] {
        var conferences = [Conference]()
        
        context.performAndWait { 
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Conference")
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    conferences = results as! [Conference]
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        return conferences
    }
    
    fileprivate func saveConferencesFromData(_ data:Data, inContext context:NSManagedObjectContext) {
        context.performAndWait {
            () -> Void in
            if data.count > 0 {
                do {
                    let conferencesDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let conferencesDict = conferencesDict as? [NSDictionary] {
                        for conferenceDict in conferencesDict {
                            guard let conference = self.getOrCreateConferenceForId(conferenceDict["id"] as! String, inContext:context) else {
                                print("Could not retrieve or create conference")
                                return
                            }
                            conference.conferenceId = conferenceDict["id"] as? String
                            conference.conferenceType = conferenceDict["confType"] as? String
                            conference.conferenceDescription = conferenceDict["confDescription"] as? String
                            conference.conferenceIconUrl = conferenceDict["confIcon"] as? String
                            conference.venue = conferenceDict["venue"] as? String
                            conference.address = conferenceDict["address"] as? String
                            conference.country = conferenceDict["country"] as? String
                            conference.latitude = conferenceDict["latitude"] as? NSNumber
                            conference.longitude = conferenceDict["longitude"] as? NSNumber
                            conference.capacity = conferenceDict["capacity"] as? NSNumber
                            conference.numberOfSessions = conferenceDict["sessions"] as? NSNumber
                            conference.hashtag = conferenceDict["hashtag"] as? String
                            conference.splashImageUrl = conferenceDict["splashImgURL"] as? String
                            conference.fromDate = conferenceDict["fromDate"] as? String
                            conference.toDate = conferenceDict["toDate"] as? String
                            conference.websiteUrl = conferenceDict["wwwURL"] as? String
                            conference.registrationUrl = conferenceDict["regURL"] as? String
                            conference.cfpUrl = conferenceDict["cfpURL"] as? String
                            conference.talkUrl = conferenceDict["talkURL"] as? String
                            conference.votingUrl = conferenceDict["votingURL"] as? String
                            conference.votingEnabled = ((conferenceDict["votingEnabled"] as! String == "true" )as NSNumber)
                            conference.votingImageName = conferenceDict["votingImageName"] as? String
                            conference.cfpEndpointUrl = conferenceDict["cfpEndpoint"] as? String
                            conference.cfpVersion = conferenceDict["cfpVersion"] as? String
                            conference.youtubeUrl = conferenceDict["youTubeURL"] as? String
                            conference.integrationId = conferenceDict["integration_id"] as? String
                        }
                        self.saveContext(context)
                    }
                } catch let jsonError as NSError {
                    print(jsonError)
                }
            }
        }
    }
    
    fileprivate func getOrCreateConferenceForId(_ id:String, inContext context:NSManagedObjectContext) -> Conference? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Conference")
        request.predicate = NSPredicate(format: "conferenceId=%@", id)
        var conference: Conference?
        
        context.performAndWait {
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    conference = results[0] as? Conference
                } else {
                    conference = NSEntityDescription.insertNewObject(forEntityName: "Conference", into: context) as? Conference
                    conference?.conferenceId = id
                    self.saveContext(context)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        return conference
    }
    
    func getSchedulesForConferenceWithId(_ conferenceId:String) -> [Schedule] {
        return self.getSchedulesForConferenceWithId(conferenceId, fromContext: self.mainObjectContext)
    }
    
    func saveSchedulesFromData(_ data: Data, forConferenceWithId conferenceId:String) {
        self.saveSchedulesFromData(data, forConferenceWithId:conferenceId, inContext: self.privateObjectContext)
    }
    
    fileprivate func getSchedulesForConferenceWithId(_ conferenceId:String, fromContext context: NSManagedObjectContext) -> [Schedule] {
        var schedules = [Schedule]()
        
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Conference")
            request.predicate = NSPredicate(format: "conferenceId=%@", conferenceId)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    guard let conference = results[0] as? Conference, let scheduleSet = conference.schedules, let scheduleArray = scheduleSet.array as? [Schedule] else {
                        schedules = [Schedule]()
                        return
                    }
                    schedules = scheduleArray
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        return schedules
    }
    
    fileprivate func getOrCreateScheduleForHref(_ href: String, inContext context: NSManagedObjectContext) -> Schedule? {
        var schedule: Schedule?
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
            request.predicate = NSPredicate(format: "href=%@", href)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    schedule = results[0] as? Schedule
                } else {
                    schedule = NSEntityDescription.insertNewObject(forEntityName: "Schedule", into: context) as? Schedule
                    schedule!.href = href
                    self.saveContext(context)
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return schedule
    }
    
    fileprivate func saveSchedulesFromData(_ data: Data, forConferenceWithId conferenceId:String, inContext context: NSManagedObjectContext) {
        context.performAndWait {
            () -> Void in
            if data.count > 0 {
                do {
                    let schedulesDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let schedulesDict = schedulesDict as? NSDictionary, let schedulesArray = schedulesDict["links"] as? NSArray {
                        guard let devoxx15 = self.getOrCreateConferenceForId(conferenceId, inContext: context) else {
                            print("Could not retrieve Devoxx15 conference")
                            return
                        }
                        var schedules = [Schedule]()
                        for scheduleDict in schedulesArray {
                            if let scheduleDict = scheduleDict as? NSDictionary {
                                guard let schedule = self.getOrCreateScheduleForHref(scheduleDict["href"] as! String, inContext: context) else {
                                    print("Could not retrieve or create schedule")
                                    return
                                }
                                schedule.title = scheduleDict["title"] as? String
                                schedule.href = scheduleDict["href"] as? String
                                schedule.conference = devoxx15
                                self.saveContext(context)
                                schedules.append(schedule)
                            }
                        }
                        devoxx15.schedules = NSOrderedSet(array: schedules)
                        self.saveContext(context)
                    }
                } catch let jsonError as NSError {
                    print(jsonError)
                }
            }
        }
    }
    
    func getSlotsForScheduleWithHref(_ href: String) -> [Slot] {
        return self.getSlotsForScheduleWithHref(href, fromContext: self.mainObjectContext)
    }
    
    fileprivate func getSlotsForScheduleWithHref(_ href: String, fromContext context: NSManagedObjectContext) -> [Slot] {
        var slots = [Slot]()
        
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
            request.predicate = NSPredicate(format: "href=%@", href)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    if let schedule = results[0] as? Schedule {
                        slots = schedule.slots!.array as! [Slot]
                    }
                }
            } catch {
                print(error)
            }
        }
        
        return slots
    }
    
    func saveSlotsFromData(_ data: Data, forScheduleWithHref href: String) {
        self.saveSlotsFromData(data, forScheduleWithHref: href, inContext: self.privateObjectContext)
    }
    
    fileprivate func configureSlot(_ slot: Slot, withData slotDict: NSDictionary, inSchedule schedule: Schedule) {
        slot.slotId = slotDict["slotId"] as? String
        slot.roomId = slotDict["roomId"] as? String
        slot.roomName = slotDict["roomName"] as? String
        slot.day = slotDict["day"] as? String
        slot.fromTime = slotDict["fromTime"] as? String
        slot.toTime = slotDict["toTime"] as? String
        slot.fromTimeMillis = slotDict["fromTimeMillis"] as? NSNumber
        slot.toTimeMillis = slotDict["toTimeMillis"] as? NSNumber
        slot.schedule = schedule
    }
    
    fileprivate func getOrCreateBreakSlotWithBreakId(_ breakId: String, inContext context: NSManagedObjectContext) -> BreakSlot? {
        var breakSlot: BreakSlot?
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BreakSlot")
            request.predicate = NSPredicate(format: "breakId=%@", breakId)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    if let slot = results[0] as? BreakSlot {
                        breakSlot = slot
                    }
                } else {
                    breakSlot = NSEntityDescription.insertNewObject(forEntityName: "BreakSlot", into: context) as? BreakSlot
                    breakSlot?.breakId = breakId
                    self.saveContext(context)
                }
            } catch {
                print(error)
            }
        }
        return breakSlot
    }
    
    fileprivate func getOrCreateTalkSlotWithTalkId(_ talkId: String, inContext context: NSManagedObjectContext) -> TalkSlot? {
        var talkSlot: TalkSlot?
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TalkSlot")
            request.predicate = NSPredicate(format: "talkId=%@", talkId)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    if let slot = results[0] as? TalkSlot {
                        talkSlot = slot
                    }
                } else {
                    talkSlot = NSEntityDescription.insertNewObject(forEntityName: "TalkSlot", into: context) as? TalkSlot
                    talkSlot?.talkId = talkId
                    self.saveContext(context)
                }
            } catch {
                print(error)
            }
        }
        return talkSlot
    }
    
    fileprivate func getOrCreateSlotWithSlotId(_ slotId: String, inContext context: NSManagedObjectContext) -> Slot? {
        var slot: Slot?
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Slot")
            request.predicate = NSPredicate(format: "slotId=%@", slotId)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    if let result = results[0] as? Slot {
                        slot = result
                    }
                } else {
                    slot = NSEntityDescription.insertNewObject(forEntityName: "Slot", into: context) as? Slot
                    slot?.slotId = slotId
                    self.saveContext(context)
                }
            } catch {
                print(error)
            }
        }
        return slot
    }
    
    fileprivate func getOrCreateTrackWithName(_ name: String, inContext context: NSManagedObjectContext) -> Track? {
        var track: Track?
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
            request.predicate = NSPredicate(format: "name=%@", name)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    if let result = results[0] as? Track {
                        track = result
                    }
                } else {
                    request.predicate = nil
                    let count = try context.count(for: request)
                    
                    track = NSEntityDescription.insertNewObject(forEntityName: "Track", into: context) as? Track
                    track?.name = name
                    track?.color = DataController.flatUiColors[count % DataController.flatUiColors.count]
                    self.saveContext(context)
                }
            } catch {
                print(error)
            }
        }
        return track
    }
    
    fileprivate func getOrCreateSpeakerWithHref(_ href: String, inContext context: NSManagedObjectContext) -> Speaker? {
        var speaker: Speaker?
        
        context.performAndWait {
            () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Speaker")
            request.predicate = NSPredicate(format: "href=%@", href)
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    if let result = results[0] as? Speaker {
                        speaker = result
                    }
                } else {
                    speaker = NSEntityDescription.insertNewObject(forEntityName: "Speaker", into: context) as? Speaker
                    speaker?.href = href
                    self.saveContext(context)
                }
            } catch {
                print(error)
            }
        }
        
        return speaker
    }
    
    fileprivate func saveSlotsFromData(_ data: Data, forScheduleWithHref href: String, inContext context: NSManagedObjectContext) {
        context.performAndWait {
            () -> Void in
            if data.count > 0 {
                guard let schedule = self.getOrCreateScheduleForHref(href, inContext: context) else {
                    return
                }
                do {
                    let scheduleDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let scheduleDict = scheduleDict as? NSDictionary {
                        if let slotsArray = scheduleDict["slots"] as? NSArray {
                            var slots = [Slot]()
                            for slotDict in slotsArray {
                                if let slotDict = slotDict as? NSDictionary {
                                    if let breakSlotDict = slotDict["break"] as? NSDictionary {
                                        let slot = self.getOrCreateBreakSlotWithBreakId(breakSlotDict["id"] as! String, inContext: context)
                                        self.configureSlot(slot!, withData: slotDict, inSchedule: schedule)
                                        
                                        slot!.breakId = breakSlotDict["id"] as? String
                                        slot!.nameEN = breakSlotDict["nameEN"] as? String
                                        slot!.nameFR = breakSlotDict["nameFR"] as? String
                                        slots.append(slot!)
                                    } else if let talkSlotDict = slotDict["talk"] as? NSDictionary {
                                        let slot = self.getOrCreateTalkSlotWithTalkId(talkSlotDict["id"] as! String, inContext: context)
                                        self.configureSlot(slot!, withData: slotDict, inSchedule: schedule)
                                        
                                        slot!.talkId = talkSlotDict["id"] as? String
                                        slot!.talkType = talkSlotDict["talkType"] as? String
                                        if let track = talkSlotDict["track"] as? String {
                                            slot!.track = self.getOrCreateTrackWithName(track, inContext: context)
                                        }
                                        slot!.summary = talkSlotDict["summary"] as? String
                                        slot!.summaryAsHtml = talkSlotDict["summaryAsHtml"] as? String
                                        slot!.title = talkSlotDict["title"] as? String
                                        slot!.lang = talkSlotDict["lang"] as? String
                                        
                                        for speaker in NSArray(array: slot!.speakers!.allObjects) {
                                            if let speaker = speaker as? Speaker {
                                                speaker.mutableSetValue(forKey: "talks").remove(slot!)
                                            }
                                        }
                                        slot!.setValue(nil, forKey: "speakers")
                                        
                                        if let speakersArray = talkSlotDict["speakers"] as? NSArray {
                                            for speakerDict in speakersArray {
                                                if let speakerDict = speakerDict as? NSDictionary {
                                                    if let linkDict = speakerDict["link"] as? NSDictionary {
                                                        if let href = linkDict["href"] as? String {
                                                            if let speaker = self.getOrCreateSpeakerWithHref(href, inContext: context) {
                                                                speaker.name = speakerDict["name"] as? String
                                                                speaker.href = href
                                                                speaker.mutableSetValue(forKey: "talks").add(slot!)
                                                                slot!.mutableSetValue(forKey: "speakers").add(speaker)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        slots.append(slot!)
                                    } else {
                                        let slot = self.getOrCreateSlotWithSlotId(slotDict["slotId"] as! String, inContext: context)
                                        self.configureSlot(slot!, withData: slotDict, inSchedule: schedule)
                                        slots.append(slot!)
                                    }
                                }
                            }
                            let sortedSlots = NSArray(array: slots).sortedArray(using: [
                                NSSortDescriptor(key: "timeRange", ascending: true),
                                NSSortDescriptor(key: "roomName", ascending: true)
                            ])
                            schedule.slots = NSOrderedSet(array: sortedSlots)
                            self.saveContext(context)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    func swapFavoriteStatusForTalkSlotWithTalkId(_ talkId:String) {
        self.swapFavoriteStatusForTalkSlotWithTalkId(talkId, inContext:self.privateObjectContext)
    }
    
    func setFavorite(_ favorite:Bool, forTalkSlotWithId talkId:String) {
        self.setFavorite(favorite, forTalkSlotWithId: talkId, inContext:self.privateObjectContext)
    }
    
    fileprivate func swapFavoriteStatusForTalkSlotWithTalkId(_ talkId:String, inContext context:NSManagedObjectContext) {
        context.performAndWait { () -> Void in
            if let talkSlot = self.getOrCreateTalkSlotWithTalkId(talkId, inContext: context) {
                talkSlot.favorite = NSNumber(value: !(talkSlot.favorite!.boolValue) as Bool)
                self.saveContext(context)
            }
        }
    }
    
    fileprivate func setFavorite(_ favorite:Bool, forTalkSlotWithId talkId:String, inContext context:NSManagedObjectContext) {
        context.performAndWait { 
            if let talkSlot = self.getOrCreateTalkSlotWithTalkId(talkId, inContext: context) {
                talkSlot.favorite = NSNumber(value: favorite as Bool)
                self.saveContext(context)
            }
        }
    }
    
    func getTalkSlotWithTalkId(_ talkId:String) -> TalkSlot? {
        return self.getOrCreateTalkSlotWithTalkId(talkId, inContext: self.mainObjectContext)
    }
    
    func getSpeakerWithHref(_ href:String) -> Speaker? {
        return self.getOrCreateSpeakerWithHref(href, inContext: self.mainObjectContext)
    }
    
    func saveSpeakerFromData(_ data:Data, forSpeakerWithHref href:String){
        self.saveSpeakerFromData(data, forSpeakerWithHref:href, inContext:self.privateObjectContext)
    }
    
    fileprivate func saveSpeakerFromData(_ data:Data, forSpeakerWithHref href:String, inContext context:NSManagedObjectContext) {
        context.performAndWait { () -> Void in
            if data.count > 0 {
                do {
                    let speakerDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let speakerDict = speakerDict as? NSDictionary {
                        if let speaker = self.getOrCreateSpeakerWithHref(href, inContext: context) {
                            speaker.uuid = speakerDict["uuid"] as? String
                            speaker.bioAsHtml = speakerDict["bioAsHtml"] as? String
                            speaker.company = speakerDict["company"] as? String
                            speaker.bio = speakerDict["bio"] as? String
                            speaker.firstName = speakerDict["firstName"] as? String
                            speaker.lastName = speakerDict["lastName"] as? String
                            speaker.avatarURL = speakerDict["avatarURL"] as? String
                            
                            self.saveContext(context)
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    func saveAvatarFromData(_ data:Data, forSpeakerWithHref href:String) {
        self.saveAvatarFromData(data, forSpeakerWithHref: href, inContext:self.privateObjectContext)
    }
    
    fileprivate func saveAvatarFromData(_ data:Data, forSpeakerWithHref href:String, inContext context:NSManagedObjectContext) {
        context.performAndWait { () -> Void in
            if let speaker = self.getOrCreateSpeakerWithHref(href, inContext: context) {
                speaker.avatar = data
                self.saveContext(context)
            }
        }
    }
    
    func getAvatarForSpeakerWithHref(_ href:String) -> Data? {
        if let speaker = self.getSpeakerWithHref(href) {
            return speaker.avatar as! Data
        } else {
            return nil
        }
    }
    
    func getFavoriteTalksAfterDate(_ date:Date) -> [TalkSlot] {
        var favoriteTalks = [TalkSlot]()
        self.mainObjectContext.performAndWait { () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TalkSlot")
            request.predicate = NSPredicate(format: "favorite==1 and fromTimeMillis>%i", date.timeIntervalSince1970 * 1000)
            request.sortDescriptors = [NSSortDescriptor(key: "fromTimeMillis", ascending: true)]
            do {
                let results = try self.mainObjectContext.fetch(request)
                favoriteTalks = results as! [TalkSlot]
            } catch let error as NSError {
                print(error)
            }
        }
        return favoriteTalks
    }
    
    func getFavoriteTalksBeforeDate(_ date:Date) -> [TalkSlot] {
        var favoriteTalks = [TalkSlot]()
        self.mainObjectContext.performAndWait { () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TalkSlot")
            request.predicate = NSPredicate(format: "favorite==1 and fromTimeMillis<%i", date.timeIntervalSince1970 * 1000)
            request.sortDescriptors = [NSSortDescriptor(key: "fromTimeMillis", ascending: true)]
            do {
                let results = try self.mainObjectContext.fetch(request)
                favoriteTalks = results as! [TalkSlot]
            } catch let error as NSError {
                print(error)
            }
        }
        return favoriteTalks
    }
    
    func getFirstTalk() -> TalkSlot? {
        var firstTalk:TalkSlot?
        self.mainObjectContext.performAndWait { () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TalkSlot")
            request.sortDescriptors = [NSSortDescriptor(key: "fromTimeMillis", ascending: true)]
            do {
                let results = try self.mainObjectContext.fetch(request)
                if results.count > 0 {
                    firstTalk = results[0] as? TalkSlot
                }
            } catch {
                print(error)
            }
        }
        return firstTalk
    }
    
    func getLastTalk() -> TalkSlot? {
        var lastTalk:TalkSlot?
        self.mainObjectContext.performAndWait { () -> Void in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TalkSlot")
            request.sortDescriptors = [NSSortDescriptor(key: "toTimeMillis", ascending: false)]
            do {
                let results = try self.mainObjectContext.fetch(request)
                if results.count > 0 {
                    lastTalk = results[0] as? TalkSlot
                }
            } catch {
                print(error)
            }
        }
        return lastTalk
    }
}
