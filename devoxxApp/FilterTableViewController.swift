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
import QuartzCore


protocol DevoxxAppFilter : NSObjectProtocol {
    func filter(filterName : [Track]) -> Void
}


extension Array {
    
    mutating func removeObject<U: AnyObject>(object: U) -> Element? {
        if count > 0 {
            for index in startIndex ..< endIndex {
                if (self[index] as! U) === object { return self.removeAtIndex(index) }
            }
        }
        return nil
    }
}


public class FilterTableViewController: UIView, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableView = UITableView()
    
    var selected = [Track]()
    
    var devoxxAppFilterDelegate:DevoxxAppFilter!
    
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
        tableView.reloadData()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("COUCOU")
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = ColorManager.bottomDotsPageController
        backgroundColor = ColorManager.bottomDotsPageController
        
        //tableView.layer.borderColor = ColorManager.topNavigationBarColor.CGColor
        //tableView.layer.borderWidth = 3.0
        
        fetchAll()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let track = fetchedResultsController.objectAtIndexPath(indexPath) as? Track {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if selected.contains(track) {
                selected.removeObject(track)
                cell?.backgroundColor = ColorManager.defaultColor
            }
            else {
                selected.append(track)
                cell?.backgroundColor = ColorManager.favoriteBackgroundColor
            }
        }
        devoxxAppFilterDelegate.filter(selected)
    }

    
   
    


    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
        
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell?.textLabel!.font = UIFont(name: "Roboto", size: 7)
            cell?.accessoryView = UIImageView(frame: CGRectMake(0,0,15,15))
            cell?.selectionStyle = .None
            cell?.backgroundColor = UIColor.clearColor()
            
        }
        
        if let track = fetchedResultsController.objectAtIndexPath(indexPath) as? Track {
            print(track.title)
            cell?.textLabel!.text = track.title
            if let cellImg = cell?.accessoryView as? UIImageView {
                cellImg.image = UIImage(named: getIconFromTrackId(track.id!))
            }
            
        }
        
        
        return cell!
        
    }
    
    public func getIconFromTrackId(trackId : String) -> String {
        return "icon_\(trackId)"
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
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
   
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Filter tracks"
    }
    
    
    
}