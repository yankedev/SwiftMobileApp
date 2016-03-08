//
//  SpeakerTableController.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//TODO make CellData optional

public class SpeakerTableController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var cellDataArray:[CellDataPrococol]?
    
    
    //var isRefreshing = false
    
    
    
    func fetchSpeaker() {

    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let predicateEvent = NSPredicate(format: "eventId = %@", APIManager.currentEvent.id!)
        let fetchRequest = NSFetchRequest(entityName: "Speaker")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicateEvent
        let sort = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sort]

        
        cellDataArray = try! managedContext.executeFetchRequest(fetchRequest) as! [CellDataPrococol]
        
            
        
       
    
    }
    
  
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        fetchAll()
        
        
        
        
        self.navigationItem.title = "Speakers"
        
        
    

    }
    
    
    
    public func fetchAll() {
        fetchSpeaker()
        self.tableView.reloadData()
    }
    
  /*  override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("WILL APPEAR")
        cellDataArray?.removeAll()
        fetchAll()
    }*/
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? SpeakerCell
        
        
        if cell == nil {
            cell = SpeakerCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .None
            cell!.configureCell()
        }
        
        
        
        
        let cellData = cellDataArray![indexPath.row]
        cell!.firstInformation.text = cellData.getFirstInformation()
        
        var shouldDisplay = false
        if indexPath.row == 0 {
            shouldDisplay = true
        }
        else {
            let previousCellDataInfo = cellDataArray![indexPath.row - 1].getFirstInformation()
            if cellData.getFirstInformation().characters.first == previousCellDataInfo.characters.first {
                shouldDisplay = false
            }
            else {
                 shouldDisplay = true
            }
        }
        
        
        
      
        if shouldDisplay {
            cell!.initiale.text = "\(cellData.getFirstInformation().characters.first!)"
        }
        else {
            cell!.initiale.text = ""
        }
        
        cell!.initiale.textColor = ColorManager.topNavigationBarColor
        cell!.initiale.font = UIFont(name: "Pirulen", size: 25)
        

        
        
        if cellData.getPrimaryImage() == nil {
            APIReloadManager.fetchSpeakerImg(cellData.getUrl(), id: cellData.getObjectID(), completedAction: okUpdate)
        }
        
     
        
        
        cell!.accessoryView = UIImageView(image: cellData.getPrimaryImage())
        cell!.accessoryView?.frame = CGRectMake(0,200,44,44)
        cell!.accessoryView!.layer.cornerRadius = cell!.accessoryView!.frame.size.width/2
        cell!.accessoryView!.layer.masksToBounds = true
        
        
        
        
        
        
        return cell!
        
    }
    
    func okUpdate(msg : String) {
        self.tableView.reloadData()
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let speaker = cellDataArray![indexPath.row] as? Speaker {
            
            
      //      print(speaker.speakerDetail.bio)
            
            
            let details = SpeakerDetailsController()
            //todo
            details.indexPath = indexPath
            details.speaker = speaker
            //details.delegate = self
            
            details.configure()
           // details.setColor(slot.favorited())
            
            self.navigationController?.pushViewController(details, animated: true)
            
            
        }
    }

    public override func viewDidAppear(animated: Bool) {
        fetchSpeaker()
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellDataArray == nil {
            return 0
        }
        return cellDataArray!.count
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    
}