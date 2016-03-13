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

public class SpeakerTableController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    var cellDataArray:[CellDataPrococol]?
    var searchedRow:[CellDataPrococol]?
    
    
    var searchingString = ""
    var searchBar = UISearchBar(frame: CGRectMake(0,0,44,44))
    
    let speakerService = SpeakerService.sharedInstance
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        tableView.reloadData()
    }
    
    
    func callBack(speakers : [Speaker], error : SpeakerStoreError?) {
        cellDataArray = speakers
        tableView.reloadData()
    }
        
    
    func fetchSpeaker() {
        speakerService.fetchSpeakers(callBack)
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .None
        
        
        self.tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        fetchSpeaker()
        
        
        
        
        self.navigationItem.title = "Speakers"
        
        
        
        
    }
    
    
    
 
    
    
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
        
        
        var arrayToParse:[CellDataPrococol]!
        if searchingString.isEmpty {
            arrayToParse = cellDataArray
        }
        else {
            arrayToParse = searchedRow
        }
        
        
        let cellData = arrayToParse![indexPath.row]
        cell!.firstInformation.text = cellData.getFirstInformation()
        
        var shouldDisplay = false
        if indexPath.row == 0 {
            shouldDisplay = true
        }
        else {
            let previousCellDataInfo = arrayToParse![indexPath.row - 1].getFirstInformation()
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
        
        cell!.accessoryView = UIImageView(image: cellData.getPrimaryImage())
        
        
        APIReloadManager.fetchImg(cellData.getUrl(), id: cellData.getObjectID(), service: SpeakerService.sharedInstance, completedAction: okUpdate)
        
        
        
        cell!.accessoryView?.frame = CGRectMake(0,200,44,44)
        cell!.accessoryView!.layer.cornerRadius = cell!.accessoryView!.frame.size.width/2
        cell!.accessoryView!.layer.masksToBounds = true
        
        
        
        
        
        
        return cell!
        
    }
    
    func okUpdate(msg : String) {
        fetchSpeaker()
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        var arrayToParse:[CellDataPrococol]!
        if searchingString.isEmpty {
            arrayToParse = cellDataArray
        }
        else {
            arrayToParse = searchedRow
        }
        
        
        if let speaker = arrayToParse![indexPath.row] as? Speaker {
            
            
            //      print(speaker.speakerDetail.bio)
            
            
            let details = SpeakerDetailsController()
            //todo
            //details.indexPath = indexPath
            
            details.detailObject = speaker
            //details.delegate = self
            
            details.configure()
            
            
            details.setColor(speaker.isFav())
            

            
            
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
    
    
    override public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    public func updateRowForSearch() {
        
        searchedRow = cellDataArray
        
        let filteredArray = searchedRow!.filter() {
            if let type = $0 as? SearchableItemProtocol {
                return type.isMatching(searchingString)
            } else {
                return false
            }
        }
        
        searchedRow = filteredArray
        
    }
    
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellDataArray == nil {
            return 0
        }
        
        if !searchingString.isEmpty {
            updateRowForSearch()
            return searchedRow!.count
        }
        return cellDataArray!.count
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    
}