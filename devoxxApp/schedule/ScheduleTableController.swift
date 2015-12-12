//
//  SchedulerTableViewController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class SchedulerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
    var seg:UISegmentedControl!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        let sort = NSSortDescriptor(key: "fromTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 20

        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "fromTime",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        APIManager.getMockedSlots(postActionParam: fetchAll, clear : true)
    }
    
    public func fetchAll() {
        var error: NSError? = nil
        if !fetchedResultsController.performFetch(&error) {
            println("unresolved error \(error), \(error!.userInfo)")
        }
        else {
            println(fetchedResultsController.sections?.count)
            
        }
        self.tableView.reloadData()
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    public func refresh() {
        println("refresh")
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("selected")
        if let slot = fetchedResultsController.objectAtIndexPath(indexPath) as? Slot {
            slot.talk.isFavorite = NSNumber(bool: !slot.talk.isFavorite.boolValue)
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            APIManager.save(managedContext)

        }
        
        
    }
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
            
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell!.configureCell()
            cell!.accessoryView?.hidden = true
        }
        
        
        if let slot = fetchedResultsController.objectAtIndexPath(indexPath) as? Slot {
            
            let talk = slot.talk
            cell!.imgView.image = UIImage(named: getIconFromTrackId(slot.talk.trackId))
            cell!.trackLabel.text = slot.talk.getShortTalkTypeName()
            cell!.talkTitle.text = "\(slot.talk.title)"
            cell!.trackLabel.backgroundColor = ColorManager.getColorFromTalkType(slot.talk.talkType)
            cell!.talkRoom.text = slot.roomName
                
            cell!.accessoryView = UIImageView(image: UIImage(named: "favoriteOn"))
            cell!.accessoryView!.frame = CGRectMake(330, 10, 20, 20)
            println(talk.isFavorite)
            cell!.accessoryView?.hidden = !talk.isFavorite.boolValue
            
        } else {
            // should be be here
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
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    
    
    
    public func changeSchedule(seg : UISegmentedControl) {
        if(seg.selectedSegmentIndex == 0) {
            fetchedResultsController.fetchRequest.predicate = nil
        }
        else {
            let predicate = NSPredicate(format: "talk.isFavorite = %d", 1)
            fetchedResultsController.fetchRequest.predicate = predicate
        }
        self.fetchAll()
    }
    
    public func getIconFromTrackId(trackId : String) -> String {
        return "icon_\(trackId)"
    }
    
    
}