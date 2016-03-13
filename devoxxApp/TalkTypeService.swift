//
//  TalkTypeService.swift
//  My_Devoxx
//
//  Created by Maxime on 13/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

class TalkTypeService : AbstractService {
    
    static let sharedInstance = TalkTypeService()
    
    override func getHelper() -> DataHelperProtocol {
        return TalkTypeHelper()
    }
    
    override func updateWithHelper(helper : [DataHelperProtocol], completionHandler : (msg: String) -> Void) {
        AttributeService.sharedInstance.updateWithHelper(helper, completionHandler: completionHandler)
    }
    
}