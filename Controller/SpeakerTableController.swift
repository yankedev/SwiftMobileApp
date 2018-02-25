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

open class SpeakerTableController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, FavoritableProtocol, HotReloadProtocol {
    
    var cellDataArray:[DataHelperProtocol]?
    var searchedRow:[DataHelperProtocol]?
    
    
    var searchingString = ""
    var searchBar = UISearchBar(frame: CGRect(x: 0,y: 0,width: 44,height: 44))
    
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        tableView.reloadData()
    }
    
    
    func callBack(_ speakers : [DataHelperProtocol], error : SpeakerStoreError?) {
        cellDataArray = speakers
        tableView.reloadData()
    }
    
    
    func fetchSpeaker() {
        SpeakerService.sharedInstance.fetchSpeakers(callBack)
    }
    
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        if let nav = self.navigationController as? HuntlyNavigationController {
            self.navigationItem.leftBarButtonItem = nav.huntlyLeftButton
        }
        
        self.tableView.separatorStyle = .none
        
        
        self.tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        
        
    
        fetchSpeaker()
        
        
        
        
        self.navigationItem.title = NSLocalizedString("Speakers", comment: "")
        
        
        
        
    }
    
    
    
    
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_1") as? SpeakerCell
        
        
        if cell == nil {
            cell = SpeakerCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .none
            cell!.configureCell()
        }
        
        
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
        
            
            
            cell!.firstInformation.text = cellDataCast.getFirstInformation()
            
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
                cell!.initiale.text = "\(firstChar)"
            }
            else {
                cell!.initiale.text = ""
            }
            
            cell!.initiale.textColor = ColorManager.topNavigationBarColor
            cell!.initiale.font = UIFont(name: "Pirulen", size: 25)
            
            cell!.accessoryView = UIImageView(image: cellDataCast.getPrimaryImage())
            

            APIReloadManager.fetchImg(cellDataCast.getUrl(), id: cellDataCast.getObjectID(), service: SpeakerService.sharedInstance, completedAction: okUpdate)
            
            
            
            cell!.accessoryView?.frame = CGRect(x: 0,y: 200,width: 44,height: 44)
            cell!.accessoryView!.layer.cornerRadius = cell!.accessoryView!.frame.size.width/2
            cell!.accessoryView!.layer.masksToBounds = true
        
        }

        return cell!
        
    }
    
    func okUpdate(_ data : CallbackProtocol) -> Void {
        fetchSpeaker()
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
    
    open override func viewDidAppear(_ animated: Bool) {
        fetchUpdate()
        fetchSpeaker()
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func favorite(_ id: NSManagedObjectID) -> Bool {
        return SpeakerService.sharedInstance.invertFavorite(id)
    }
    
    override open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    open func updateRowForSearch() {
        
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
    
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellDataArray == nil {
            return 0
        }
        
        if !searchingString.isEmpty {
            updateRowForSearch()
            return searchedRow!.count
        }
        return cellDataArray!.count
    }
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    open func fetchUpdate() {
        print("goto : \(fetchUrl())")
        APIReloadManager.fetchUpdate(fetchUrl(), service: SpeakerService.sharedInstance, completedAction: fetchCompleted)
    }
    
    open func fetchCompleted(_ msg : CallbackProtocol) -> Void {
        fetchSpeaker()
    }
    
    open func fetchUrl() -> String? {
        return SpeakerService.sharedInstance.getSpeakerUrl()
    }
    
    
}
