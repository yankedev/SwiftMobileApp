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

public class FilterTableViewController: UITableView, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    

    
    
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
        reloadData()
    }
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        print("COUCOU")
        self.dataSource = self
        self.delegate = self
        fetchAll()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
  
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
        
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
        }
        
        if let track = fetchedResultsController.objectAtIndexPath(indexPath) as? Track {
            print(track.title)
            cell?.textLabel!.text = track.title
        }
        
        
        return cell!
        
    }
    
    
    
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            print("nomberOfSections\(sections.count)")
            return sections.count
        }
        
        return 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            print("numberOfRowsInSection\(sections[section].numberOfObjects)")
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "title"
    }
    
    
    
}