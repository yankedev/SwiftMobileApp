//
//  SearchableProcotol.swift
//  devoxxApp
//
//  Created by maxday on 02.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import UIKit
import CoreData

public protocol SearchableProcotol  {
    func isMatching(str : String) -> Bool
}


protocol SearchableTableProtocol {
    
    var searchPredicates:[String : [NSPredicate]] { get set }
    var searchingString:String { get set }
    var searchBar:UISearchBar { get set }
    var searchedSections:[NSFetchedResultsSectionInfo] { get set }

}

protocol ScrollableTableProtocol {
    
    var index:NSInteger { get set }
    var currentDate:NSDate! { get set}
    
}