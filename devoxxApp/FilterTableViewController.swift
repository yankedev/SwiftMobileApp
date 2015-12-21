//
//  FilterTableViewController.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public protocol DevoxxAppFilter : NSObjectProtocol {
    func filter(filterName : String) -> Void
}

public class FilterTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    var delegate:DevoxxAppFilter!
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Track")
        let sort = NSSortDescriptor(key: "title", ascending: true)
       
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [sort]
     
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()

    public func fetchAll() {
        
        var error: NSError? = nil
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error1 as NSError {
            error = error1
            print("unresolved error \(error), \(error!.userInfo)")
        }
        print(fetchedResultsController.fetchedObjects?.count)
        self.tableView.reloadData()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //fetchAll()
        
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
        if let track = fetchedResultsController.objectAtIndexPath(indexPath) as? Track {
            self.delegate?.filter(track.id!)
        }
    }
    
  
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
        
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
        }
        
        if let track = fetchedResultsController.objectAtIndexPath(indexPath) as? Track {
            cell?.textLabel!.text = track.title
        }
        
        
        return cell!
        
    }
    
    
    
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
    
    
    
}