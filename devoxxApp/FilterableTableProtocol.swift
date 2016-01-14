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
    func buildFilter(filters : [String: [FilterableProtocol]])
    func filter()
    func getCurrentFilters() -> [String : [FilterableProtocol]]?
}
