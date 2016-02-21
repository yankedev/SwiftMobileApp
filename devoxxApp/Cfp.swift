//
//  Cfp.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public protocol EventProtocol  {
    func title() -> String
    func splashImageName() -> String
    func numbers() -> Array<Int>
    func backgroundImage() -> NSData
}

class Cfp: NSManagedObject, FeedableProtocol, EventProtocol {

    @NSManaged var id: String?
    @NSManaged var confType: String?
    @NSManaged var confDescription: String?
    @NSManaged var venue: String?
    @NSManaged var address: String?
    @NSManaged var country: String?
    @NSManaged var capacity: String?
    @NSManaged var sessions: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var splashImgURL: String?
    @NSManaged var backgroundImageData: NSData?
    @NSManaged var floors: NSSet
    

    func feedHelper(helper: DataHelperProtocol) -> Void {
        if let castHelper = helper as? CfpHelper  {
            
            id = castHelper.id
            confType = castHelper.confType
            confDescription = castHelper.confDescription
            venue = castHelper.venue
            address = castHelper.address
            country = castHelper.country
            capacity = castHelper.capacity
            sessions = castHelper.sessions
            latitude = castHelper.latitude
            longitude = castHelper.longitude
            splashImgURL = castHelper.splashImgURL

            if let path = NSBundle.mainBundle().pathForResource(splashImgURL, ofType: "jpg") {
                if let data = NSData(contentsOfFile: path) {
                    backgroundImageData = data
                }
            }
            
        }
    }
    
    func title() -> String {
        return country!
    }
    
    func splashImageName() -> String {
        return "splash_btn_\(id!).png"
    }
    
    func numbers() -> Array<Int> {
        return [10, 20, 30]
    }
    
    func backgroundImage() -> NSData {
        return backgroundImageData!
    }
    
    func getImages() -> [Floor] {
        var result = [Floor]()
        for floor in floors  {
            if let realFloor = floor as? Floor  {
                if realFloor.target == APIManager.getStringDevice() {
                    result.append(realFloor)
                }
            }
        }
        return result.sort({ $0.tabpos < $1.tabpos })
    }

}
