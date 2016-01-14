//
//  CommonHelper.swift
//  devoxxApp
//
//  Created by maxday on 15.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class CommonHelper {

    class func getTintColorFromTag(tag : Int) -> UIColor {
        if tag == 0  {
            return UIColor.blackColor()
        }
        return UIColor.whiteColor()
    }
}
