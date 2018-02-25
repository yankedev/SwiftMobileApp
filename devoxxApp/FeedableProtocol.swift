//
//  FeedableProtocol.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public protocol FeedableProtocol  {
    func feedHelper(_ help: DataHelperProtocol)
    func getId() -> NSManagedObject?
    func resetId(_ id : NSManagedObject?)
}
