//
//  CallbackProtocol.swift
//  My_Devoxx
//
//  Created by Maxime on 15/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

public protocol CallbackProtocol {
    
    func getHelper() -> DataHelperProtocol?
    func getImg() -> Data?
    func debug() -> String
    func getMessage() -> String


}

class CompletionMessage : CallbackProtocol {
    var msg : String = ""
    var img : Data?
    var helper : DataHelperProtocol?
    
    init(msg : String) {
        self.msg = msg
    }
    init(obj : DataHelperProtocol) {
        self.helper = obj
    }
    init(img : Data?) {
        self.img = img
    }

    func getHelper() -> DataHelperProtocol? {
        return helper
    }
    func getImg() -> Data? {
        return img
    }
    
    func getMessage() -> String {
        return msg ?? ""
    }
    
    func debug() -> String {
        return "\(msg) \(helper)"
    }
}
