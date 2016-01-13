//
//  Feedable.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public protocol FeedableProtocol  {
    func feedHelper(help: DataHelperProtocol)
    func exists(id : String, leftPredicate: String, entity: String) -> Bool
}
