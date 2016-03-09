//
//  ScrollableTableProtocol.swift
//  devoxxApp
//
//  Created by maxday on 15.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollableDateTableDatasource : UIPageViewControllerDelegate {

    var allDates:NSArray! {get set}
    var allTracks:NSArray! {get set}
    
}

protocol ScrollableDateTableDelegate : UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController! { get set}
    func feedDate()
    
}