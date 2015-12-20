//
//  FilterTableViewController.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit


public protocol DevoxxAppFilter : NSObjectProtocol {
    func filter(filterName : String) -> Void
}

public class FilterTableViewController: UITableViewController {
    
    
    var delegate:DevoxxAppFilter!
    
    
    override public func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        let finalCenter = tableView.center
        let beginCenter = CGPointMake(finalCenter.x - tableView.frame.width, finalCenter.y)
        
        tableView.center = beginCenter
        
       
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.center = finalCenter
        })
    }
    
  
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        
    view.backgroundColor = UIColor.redColor()
    }
 
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.filter("University")
    }
    
  
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
        
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
        }
        
        cell?.textLabel!.text = "HELLO"
        
        return cell!
        
    }
    
    
    
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
    
    
    
}