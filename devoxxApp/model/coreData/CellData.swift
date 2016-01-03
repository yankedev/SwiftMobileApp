//
//  CellData.swift
//  devoxxApp
//
//  Created by maxday on 24.12.15.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc protocol CellDataPrococol : NSObjectProtocol {
    
    func getFirstInformation() -> String
    func getSecondInformation() -> String
    func getThirdInformation() -> String
    func getPrimaryImage() -> UIImage?
    func getColor() -> UIColor?
    //func isFavorite() -> Bool
    func getElement() -> NSManagedObject

}
