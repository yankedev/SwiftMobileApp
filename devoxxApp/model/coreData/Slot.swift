//
//  Slot.swift
//  devoxxApp
//
//  Created by maxday on 10.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class Slot: CellData, FavoriteProtocol {

    @NSManaged var roomName: String
    @NSManaged var slotId: String
    @NSManaged var fromTime: String
    @NSManaged var day: String
    
    @NSManaged var toTimeMillis: NSNumber
    
    @NSManaged var talk: Talk
    
    
    
    
    override func getPrimaryImage() -> UIImage? {
        return UIImage(named: talk.getIconFromTrackId())
    }
    
    override func getFirstInformation() -> String {
        return talk.title
    }
    
    override func getSecondInformation() -> String {
        return roomName
    }
    
    override func getThirdInformation() -> String {
        return talk.getShortTalkTypeName()
    }
    
    override func getColor() -> UIColor? {
        return ColorManager.getColorFromTalkType(talk.talkType)
    }
    
    override func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? SlotHelper  {
            roomName = castHelper.roomName!
            slotId = castHelper.slotId!
            fromTime = castHelper.fromTime!
            day = castHelper.day!
        }
    }
    
    override func getElement() -> NSManagedObject {
        return talk
    }

    func getIdentifier() -> String {
        return talk.id
    }
    
    func invertFavorite() -> Bool {
        return APIManager.invertFavorite("Talk", identifier: getIdentifier())
    }
    
    func favorited() -> Bool {
        return APIManager.isFavorited("Talk", identifier: getIdentifier())
    }
    
}
