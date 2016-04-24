//
//  CfpHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-06.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import Unbox

struct CfpHelper: Unboxable, DataHelperProtocol {
    
    
    var id: String?
    var integration_id: String?
    var confType: String?
    var confDescription: String?
    var venue: String?
    var address: String?
    var country: String?
    var capacity: String?
    var sessions: String?
    var latitude: String?
    var longitude: String?
    var talkURL: String?
    var splashImgURL: String?
    var hashtag: String?
    var fromDate: String?
    var regURL: String?
    var cfpEndpoint: String?
    var votingImageName: String?
    
    var fedFloorsArray:Array<DataHelperProtocol>!
    
    init() {
    }
    
    init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.integration_id = unboxer.unbox("integration_id")
        self.confType = unboxer.unbox("confType")
        self.confDescription = unboxer.unbox("confDescription")
        self.venue = unboxer.unbox("venue")
        self.address = unboxer.unbox("address")
        self.country = unboxer.unbox("country")
        self.capacity = unboxer.unbox("capacity")
        self.sessions = unboxer.unbox("sessions")
        self.latitude = unboxer.unbox("latitude")
        self.longitude = unboxer.unbox("longitude")
        self.talkURL = unboxer.unbox("talkURL")
        self.splashImgURL = unboxer.unbox("splashImgURL")
        self.hashtag = unboxer.unbox("hashtag")
        self.confType = unboxer.unbox("confType")
        self.fromDate = unboxer.unbox("fromDate")
        self.regURL = unboxer.unbox("regURL")
        self.cfpEndpoint = unboxer.unbox("cfpEndpoint")
        self.votingImageName = unboxer.unbox("votingImageName")
    }
    
    
    init(id: String?, integration_id: String?, confType: String?, confDescription: String?, venue: String?, address: String?, country: String?, capacity: String?, sessions: String?, latitude:String?, longitude:String?, splashImgURL: String?, hashtag: String?, fromDate: String?, talkURL: String?, regURL : String?, cfpEndpoint : String?, votingImageName : String?) {
        self.id = id ?? ""
        self.integration_id = integration_id ?? ""
        self.confType = confType ?? ""
        self.confDescription = confDescription ?? ""
        self.venue = venue ?? ""
        self.address = address ?? ""
        self.country = country ?? ""
        self.regURL = regURL ?? ""
        self.fromDate = fromDate ?? ""
        self.talkURL = talkURL ?? ""
        self.capacity = capacity ?? ""
        self.sessions = sessions ?? ""
        self.latitude = latitude ?? ""
        self.cfpEndpoint = cfpEndpoint ?? ""
        self.longitude = longitude ?? ""
        self.splashImgURL = splashImgURL ?? ""
        self.hashtag = hashtag ?? ""
        self.votingImageName = votingImageName ?? ""
        
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    func getMainId() -> String {
        return id!
    }
    
    mutating func feed(data: JSON) {
        
        id = data["id"].string
        integration_id = data["integration_id"].string
        confType = data["confType"].string
        confDescription = data["confDescription"].string
        venue = data["venue"].string
        address = data["address"].string
        country = data["country"].string
        talkURL = data["talkURL"].string
        cfpEndpoint = data["cfpEndpoint"].string
        capacity = data["capacity"].string
        fromDate = data["fromDate"].string
        sessions = data["sessions"].string
        regURL = data["regURL"].string
        latitude = data["latitude"].string
        longitude = data["longitude"].string
        splashImgURL = data["splashImgURL"].string
        hashtag = data["hashtag"].string
        votingImageName = data["votingImageName"].string
        
        fedFloorsArray = Array<FloorHelper>()
        
        if let floorArray = data["floors"].array {
            
            for spk in floorArray {
                let floorHelper = FloorHelper()
                floorHelper.feed(spk)
                floorHelper.id = id
                fedFloorsArray.append(floorHelper)
            }
            
        }
        
    }
    
    func entityName() -> String {
        return "Cfp"
    }
    
    func prepareArray(json: JSON) -> [JSON]? {
        return json.array
    }
    
}