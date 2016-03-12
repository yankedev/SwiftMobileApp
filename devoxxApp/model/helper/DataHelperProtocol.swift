//
//  DataHelperProtocol.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation

public protocol DataHelperProtocol {
    func feed(data: JSON)
    func entityName() -> String
    func prepareArray(json : JSON) -> [JSON]?
    func typeName() -> String
    func getMainId() -> String
}

