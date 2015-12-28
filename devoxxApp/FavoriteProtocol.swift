//
//  FavoriteProtocol.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-27.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation


public protocol FavoriteProtocol : NSObjectProtocol {
    func getIdentifier() -> String
    func favorited() -> Bool
    func invertFavorite() -> Bool
}