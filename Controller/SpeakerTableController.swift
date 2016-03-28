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

public class SpeakerTableController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, FavoritableProtocol, HotReloadProtocol {
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var cellDataArray:[DataHelperProtocol]?
    var searchedRow:[DataHelperProtocol]?
    
    var searchingString = ""
    
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        tableView.reloadData()
    }
    
    
    func callBack(speakers : [DataHelperProtocol], error : SpeakerStoreError?) {
        cellDataArray = speakers
        tableView.reloadData()
    }
    
    
    func fetchSpeaker() {
        SpeakerService.sharedInstance.fetchSpeakers(callBack)
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .None
        
       
        searchBar.delegate = self
        
        
    
        fetchSpeaker()
        
        
        
        
        self.navigationItem.title = NSLocalizedString("Speakers", comment: "")
        
        
        
        
    }
    
    
    
    
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? SpeakerCell
        
     
        var arrayToParse:[DataHelperProtocol]!
        if searchingString.isEmpty {
            arrayToParse = cellDataArray
        }
        else {
            arrayToParse = searchedRow
        }
        
        
        let cellData = arrayToParse![indexPath.row]
        
        
        if let cellDataFav = cellData as? FavoriteProtocol {
            cell!.updateBackgroundColor(cellDataFav.isFav())
        }
        
        if let cellDataCast = cellData as? CellDataDisplayPrococol {
        
           
          
            
            cell!.firstInformation?.text = cellDataCast.getFirstInformation()
            
            
            
            var shouldDisplay = false
            if indexPath.row == 0 {
                shouldDisplay = true
            }
            else {
                let previousCellData = arrayToParse![indexPath.row - 1] as! CellDataDisplayPrococol
                let previousCellDataInfo = previousCellData.getFirstInformation()
       
                if cellDataCast.getFirstInformation()?.characters.first == previousCellDataInfo?.characters.first {
                    shouldDisplay = false
                }
                else {
                    shouldDisplay = true
                }
            }
            
            
            
            
            if shouldDisplay {
                let firstChar = (cellDataCast.getFirstInformation()?.characters.first)!
                cell!.initiale?.text = "\(firstChar)"
            }
            else {
                cell!.initiale?.text = ""
            }
            
            cell!.initiale?.textColor = ColorManager.topNavigationBarColor
            cell!.initiale?.font = UIFont(name: "Pirulen", size: 25)
            
            cell!.accessoryView = UIImageView(image: cellDataCast.getPrimaryImage())
            

            APIReloadManager.fetchImg(cellDataCast.getUrl(), id: cellDataCast.getObjectID(), service: SpeakerService.sharedInstance, completedAction: okUpdate)
            
            
            
           
            cell!.speakerProfilePicture!.layer.cornerRadius = cell!.speakerProfilePicture!.frame.size.width/2
            cell!.speakerProfilePicture!.layer.masksToBounds = true
            cell!.speakerProfilePicture!.backgroundColor = UIColor.redColor()
        
        }

       
        return cell!
 
        
    }
    
    func okUpdate(data : CallbackProtocol) -> Void {
        fetchSpeaker()
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        var arrayToParse:[DataHelperProtocol]!
        if searchingString.isEmpty {
            arrayToParse = cellDataArray
        }
        else {
            arrayToParse = searchedRow
        }
        
        
        
        
        if let speaker = arrayToParse![indexPath.row] as? SpeakerHelper {
            
            
            //      print(speaker.speakerDetail.bio)
            
            
            let details = SpeakerDetailsController()
            //todo
            //details.indexPath = indexPath
            
            details.detailObject = speaker
            details.delegate = self
            
            details.configure()
            
            
            details.setColor(speaker.isFavorite!)
            
            
            
            
            //details.setColor(slot.favorited())
            
            self.navigationController?.pushViewController(details, animated: true)
            
            
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        fetchUpdate()
        fetchSpeaker()
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func favorite(id: NSManagedObjectID) -> Bool {
        return SpeakerService.sharedInstance.invertFavorite(id)
    }
    
    override public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
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
        print(cellDataArray!.count)
        return cellDataArray!.count
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    public func fetchUpdate() {
        //print("goto : \(fetchUrl())")
        APIReloadManager.fetchUpdate(fetchUrl(), service: SpeakerService.sharedInstance, completedAction: fetchCompleted)
    }
    
    public func fetchCompleted(msg : CallbackProtocol) -> Void {
        fetchSpeaker()
    }
    
    public func fetchUrl() -> String? {
        return SpeakerService.sharedInstance.getSpeakerUrl()
    }
    
    
}