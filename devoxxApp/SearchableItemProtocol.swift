//
//  SearchableItemProtocol.swift
//  devoxxApp
//
//  Created by maxday on 15.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

protocol SearchableItemProtocol {
    func isMatching(_ str : String) -> Bool
}
