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
    
    var cellDataArray:[CellData]?
    
    func fetchSpeaker() {

    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Speaker")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false

        let sort = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sort]

        
        cellDataArray = try! managedContext.executeFetchRequest(fetchRequest) as! [CellData]
        
        //print(speakerArray)
    
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        
        //APIManager.getMockedSpeakers(postActionParam: fetchSpeaker, clear: true)
        
        APIManager.getMockedObjets(postActionParam: fetchSpeaker, clear: true, dataHelper: SpeakerHelper.self)
        
        
        
    }
    
    
    
    public func fetchAll() {
        fetchSpeaker()
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
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? ScheduleViewCell
        
        
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .None
            cell!.configureCell()
        }
        
        
        
        
        let cellData = cellDataArray![indexPath.row]
        cell!.talkTitle.text = cellData.getFirstInformation()
        //TODO is favorited cell!.updateBackgroundColor(speaker)
       
        
        
        return cell!
        
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