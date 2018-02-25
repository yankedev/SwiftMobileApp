//
//  FilterableTableProtocol.swift
//  devoxxApp
//
//  Created by maxday on 02.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import CoreData

protocol FilterableTableProtocol {
    
    var currentFilters:[String : [FilterableProtocol]]! {get set}
    
    func clearFilter()
    func buildFilter(_ filters : [String: [FilterableProtocol]])
    func filter()
    func getCurrentFilters() -> [String : [FilterableProtocol]]?
}
