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
    
    var searchBar = UISearchBar(frame: CGRect(x: 0,y: 0,width: 44,height: 44))
    
    func updateHeaderView(_ show : Bool) {
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
        self.init(frame: CGRect.zero, style : .plain)
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
        
        let verticalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionnary)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionnary)
        
        superview?.addConstraints(horizontalContraint)
        superview?.addConstraints(verticalContraint)
    }
    
}
