//
//  FilterableProtocol.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-31.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public protocol FilterableProtocol {
    func filterPredicateLeftValue() -> String
    func filterPredicateRightValue() -> String
    func filterMiniIcon() -> UIImage?
    func niceLabel() -> String
}

