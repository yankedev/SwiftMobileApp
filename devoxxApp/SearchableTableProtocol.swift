//
//  SearchableTableProtocol.swift
//  devoxxApp
//
//  Created by maxday on 02.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import UIKit
import CoreData


protocol SearchableTableProtocol {
    
    var searchPredicates:[String : [NSPredicate]] { get set }
    var searchingString:String { get set }
    var searchedSections:[NSFetchedResultsSectionInfo] { get set }

}
