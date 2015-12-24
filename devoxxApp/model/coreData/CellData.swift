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

class CellData: Feedable {
    
    func getFirstInformation() -> String {
        return "Default first information"
    }
    
    func getSecondInformation() -> String {
        return "Default second information"
    }
    
    func getThirdInformation() -> String {
        return "Default forth information"
    }
    
    func getPrimaryImage() -> UIImage? {
        return UIImage(named: "defaultImage")
    }
    
    func getColor() -> UIColor? {
        return UIColor.blackColor()
    }
    
    func isFavorite() -> Bool {
        return false
    }
    
    func invertFavorite() -> Void {
    }
    
    
    
}
