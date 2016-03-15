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
    func getImg() -> NSData?
    func debug() -> String


}

class CompletionMessage : CallbackProtocol {
    var msg : String = ""
    var img : NSData?
    var helper : DataHelperProtocol?
    
    init(msg : String) {
        self.msg = msg
    }
    init(obj : DataHelperProtocol) {
        self.helper = obj
    }
    init(img : NSData?) {
        self.img = img
    }

    func getHelper() -> DataHelperProtocol? {
        return helper
    }
    func getImg() -> NSData? {
        return img
    }
    
    func debug() -> String {
        return "\(msg) \(helper)"
    }
}