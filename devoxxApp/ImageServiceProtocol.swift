//
//  ImageServiceProtocol.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

protocol ImageServiceProtocol {

    func updateImageForId(_ id : NSManagedObjectID, withData data: Data, completionHandler : ((_ msg: CallbackProtocol) -> Void)?)

}
