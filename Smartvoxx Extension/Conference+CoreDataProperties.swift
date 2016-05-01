//
//  Conference+CoreDataProperties.swift
//  My_Devoxx
//
//  Created by Sebastien Arbogast on 09/04/2016.
//  Copyright © 2016 maximedavid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Conference {

    @NSManaged var conferenceId: String?
    @NSManaged var conferenceType: String?
    @NSManaged var conferenceDescription: String?
    @NSManaged var conferenceIconUrl: String?
    @NSManaged var venue: String?
    @NSManaged var address: String?
    @NSManaged var country: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var capacity: NSNumber?
    @NSManaged var numberOfSessions: NSNumber?
    @NSManaged var hashtag: String?
    @NSManaged var splashImageUrl: String?
    @NSManaged var fromDate: String?
    @NSManaged var toDate: String?
    @NSManaged var websiteUrl: String?
    @NSManaged var registrationUrl: String?
    @NSManaged var cfpUrl: String?
    @NSManaged var talkUrl: String?
    @NSManaged var votingUrl: String?
    @NSManaged var votingEnabled: NSNumber?
    @NSManaged var votingImageName: String?
    @NSManaged var cfpEndpointUrl: String?
    @NSManaged var cfpVersion: String?
    @NSManaged var youtubeUrl: String?
    @NSManaged var integrationId: String?
    @NSManaged var schedules: NSOrderedSet?

}
