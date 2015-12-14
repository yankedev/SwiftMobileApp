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


public protocol DevoxxAppScheduleDelegate : NSObjectProtocol {
    func isMySheduleSelected() -> Bool
}

public class SchedulerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ScheduleViewCellDelegate {
    
    var delegate:DevoxxAppScheduleDelegate!
  
    var navigationItemParam:UINavigationItem!
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        let sort = NSSortDescriptor(key: "fromTime", ascending: true)
        
        //var lastDragged : ScheduleViewCell!
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 20
        let predicate = NSPredicate(format: "day = %@", APIManager.getDayFromIndex(self.view.tag))
        fetchRequest.predicate = predicate

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
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        
    
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        

               

        
        
        
        
        
        
    }
    
    
    
    public func fetchAll() {
        let predicateDay = NSPredicate(format: "day = %@", APIManager.getDayFromIndex(self.view.tag))
        if(delegate.isMySheduleSelected()) {
            let predicateFavorite = NSPredicate(format: "talk.isFavorite = %d", 1)
            fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateDay, predicateFavorite])
        }
        else {
            fetchedResultsController.fetchRequest.predicate = predicateDay
        }
        var error: NSError? = nil
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error1 as NSError {
            error = error1
            print("unresolved error \(error), \(error!.userInfo)")
        }
        self.tableView.reloadData()
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        APIManager.getMockedSlots(postActionParam: fetchAll, clear : false, index: self.view.tag)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let scheduleCell = cell as? ScheduleViewCell {
            if(scheduleCell.scrollView.contentOffset.x == 0) {
                saveAsFavorite(indexPath)
                scheduleCell.hideFavorite(animated: true)
                
                if let slot = fetchedResultsController.objectAtIndexPath(indexPath) as? Slot {
                
                    scheduleCell.btnFavorite.selected = slot.talk.isFavorite.boolValue
                    scheduleCell.updateBackgroundColor()
                }
                
            }
            else {
                if let slot = fetchedResultsController.objectAtIndexPath(indexPath) as? Slot {
                
                    let details = TalkDetailsController()
                    details.talk = slot.talk
                        self.navigationController?.pushViewController(details, animated: true)
                    
                }
                
            }
        }
        
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
            
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .None
            cell?.delegate = self
            cell!.configureCell()
            cell!.indexPath = indexPath
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("clicked:"))

            //cell!.scrollView.addGestureRecognizer(tapGestureRecognizer)
            
            cell!.updateBackgroundColor()
            
            
        }
        
        
        if let slot = fetchedResultsController.objectAtIndexPath(indexPath) as? Slot {
            
            let talk = slot.talk
            cell!.indexPath = indexPath
            cell!.imgView.image = UIImage(named: getIconFromTrackId(slot.talk.trackId))
            cell!.trackLabel.text = slot.talk.getShortTalkTypeName()
            cell!.talkTitle.text = "\(slot.talk.title)"
            cell!.trackLabel.backgroundColor = ColorManager.getColorFromTalkType(slot.talk.talkType)
            cell!.talkRoom.text = slot.roomName
            cell!.btnFavorite.selected = slot.talk.isFavorite.boolValue
            cell!.updateBackgroundColor()
            
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
    
    
  
    
    public func changeSchedule(isMySchedule isMySchedule : Bool) {
        print("changeSchwedule = \(self.view.tag)")
        self.hideAllFavorite(except:nil, animated: false)
        self.fetchAll()
    }
    
    public func getIconFromTrackId(trackId : String) -> String {
        return "icon_\(trackId)"
    }
    
    public override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        hideAllFavorite(except: nil, animated: true)
    }
    
    func hideAllFavorite(except except: ScheduleViewCell?, animated: Bool) {
        for singleCell in self.tableView.visibleCells {
            if let singleScheduleViewCell = singleCell as? ScheduleViewCell {
                if singleScheduleViewCell != except {
                    singleScheduleViewCell.hideFavorite(animated: animated)
                }
            }
        }
    }
    
    func beginScroll(sender: ScheduleViewCell) -> Void {
        hideAllFavorite(except: sender, animated: true)
    
    }
    
    public override func viewDidAppear(animated: Bool) {
        print("currentIndex : \(index)")
    }
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func saveAsFavorite(indexPath : NSIndexPath) -> Void {
        if let slot = fetchedResultsController.objectAtIndexPath(indexPath) as? Slot {
            
            slot.talk.isFavorite = NSNumber(bool: !slot.talk.isFavorite.boolValue)

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            APIManager.save(managedContext)
        }
    }
    
       
}