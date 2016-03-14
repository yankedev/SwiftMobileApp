//
//  SchedulerTableView.swift
//  devoxxApp
//
//  Created by maxday on 14.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class SchedulerTableView : UITableView {

    var searchBar = UISearchBar(frame: CGRectMake(0,0,44,44))
    
    func updateHeaderView(show : Bool) {
        if show {
            tableHeaderView = searchBar
        }
        else {
            tableHeaderView = nil
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style:style)
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero, style : .Plain)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        //separatorStyle = .None
    }
    
    func setupConstraints() {
        let viewDictionnary = ["tableView": self]
        
        let verticalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionnary)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionnary)
        
        superview?.addConstraints(horizontalContraint)
        superview?.addConstraints(verticalContraint)
    }
    
}