//
//  TrackService.swift
//  My_Devoxx
//
//  Created by Maxime on 13/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

class TrackService : AbstractService {
    
    static let sharedInstance = TrackService()
    
    override func getHelper() -> DataHelperProtocol {
        return TrackHelper()
    }
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: CallbackProtocol) -> Void) {
        AttributeService.sharedInstance.updateWithHelper(helper, completionHandler: completionHandler)
    }

}
