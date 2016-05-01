//
//  SpeakerCell.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-17.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

class SpeakerCell: UITableViewCell {

    @IBOutlet weak var firstInformation: UILabel!
    @IBOutlet weak var initiale: UILabel!
    @IBOutlet var speakerProfilePicture: UIImageView!
    
       func updateBackgroundColor(isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    
}
