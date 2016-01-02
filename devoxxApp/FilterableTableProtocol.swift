//
//  FilterableTableProtocol.swift
//  devoxxApp
//
//  Created by maxday on 02.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

protocol FilterableTableProtocol {
    func clearFilter()
    func buildFilter(filters : [String: [Attribute]])
    func filter()
}
