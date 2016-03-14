//
//  TrackTableViewController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class TrackTableViewController<T : CellDataPrococol>:
    UIViewController,
    UITableViewDelegate,
    SearchableTableProtocol,
    UITableViewDataSource,
    UISearchBarDelegate,
    ScrollableDateProtocol,
    FavoritableProtocol
{
    
    
    
    var managedContext:NSManagedObjectContext!
    
    
    var sortedSlot:[Slot]!
    
    //ScrollableDateProtocol
    public var index:Int = 0
    public var currentTrack:NSManagedObjectID!
    public var currentDate:NSDate!
    
    public func getNavigationItem() -> UINavigationItem {
        return (self.navigationController?.navigationItem)!
    }
    
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var openedSections = [Bool]()
    
    
    
    //SerchableTableProtocol
    var searchPredicates = [String : [NSPredicate]]()
    var searchingString = ""
    
    var searchedSections = [NSFetchedResultsSectionInfo]()
    
    
    
    
    var schedulerTableView = SchedulerTableView()
    
    var presort = Array<[Slot]>()
    
    let talkService = TalkService.sharedInstance
    var savedFetchedResult : NSFetchedResultsController?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        schedulerTableView.delegate = self
        schedulerTableView.dataSource = self
        
        schedulerTableView.searchBar.delegate = self
        schedulerTableView.updateHeaderView(true)
        self.view.addSubview(schedulerTableView)
        schedulerTableView.setupConstraints()
    }
    
    
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchAll()
        
        
        
        self.schedulerTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
        
        
        
        
        
        
    }
    
    
    private func computePredicate() -> NSPredicate {
        
        
        var andPredicate = [NSPredicate]()
        let predicateDay = NSPredicate(format: "track = %@", self.currentTrack)
        let predicateEvent = NSPredicate(format: "slot.cfp.id = %@", CfpService.sharedInstance.getCfpId())
        
        andPredicate.append(predicateDay)
        andPredicate.append(predicateEvent)
        
        var attributeOrPredicate = [NSPredicate]()
        
        for name in searchPredicates.keys {
            attributeOrPredicate.append(NSCompoundPredicate(orPredicateWithSubpredicates: searchPredicates[name]!))
        }
        
        andPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: attributeOrPredicate))
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
    }
    
    
    public func resetSearch() {
        searchingString = ""
    }
    
    public func performSwitch() {
        resetSearch()
        fetchAll()
    }
    
    
    
    //TableView
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let detailObject = getCell(indexPath) as? DetailableProtocol {
            
            
            
            
            let details = TalkDetailsController()
            details.detailObject = detailObject
            details.delegate = self
            
            
            details.configure()
            
            if let favorite = detailObject as? FavoriteProtocol {
                details.setColor(favorite.isFav())
            }
            self.navigationController?.pushViewController(details, animated: true)
            
            
        }
    }
    
    
    public func favorite(id : NSManagedObjectID) -> Bool {
        return talkService.invertFavorite(id)
    }
    
    
    
    
    
    func getCell(indexPath : NSIndexPath) -> CellDataPrococol? {
        
        var cellDataTry:CellDataPrococol?
        
        if !searchingString.isEmpty {
            
            let curent = searchedSections[indexPath.section]
            let obj = (curent.objects)!
            cellDataTry = filterSearchArray(obj)[indexPath.row] as? CellDataPrococol
            return cellDataTry
        }
            
        else {
            return savedFetchedResult?.objectAtIndexPath(indexPath) as? CellDataPrococol
        }
        
    }
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10") as? ScheduleCellView
        
        if cell == nil {
            cell = ScheduleCellView(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
        }
        
        if let cellData = getCell(indexPath) {
            
            cell!.leftIconView.imageView.image = cellData.getPrimaryImage()
            
            cell!.rightTextView.topTitleView.talkTrackName.text = cellData.getThirdInformation()
            cell!.rightTextView.topTitleView.talkTitle.text = cellData.getFirstInformation()
            
            cell!.rightTextView.locationView.label.text = cellData.getSecondInformation()
            cell!.rightTextView.speakerView.label.text = cellData.getForthInformation(false)
            
            
            if let fav = cellData as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.isFav())
            }
            
            return cell!
            
        } else {
            // todo should be be here
        }
        
        return UITableViewCell()
    }
    
    
  
    
    
    
    func filterSearchArray(currentArray : [AnyObject]) -> [AnyObject] {
        
        let filteredArray = currentArray.filter() {
            if let type = $0 as? SearchableItemProtocol {
                return type.isMatching(searchingString)
            } else {
                return false
            }
        }
        
        return filteredArray
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let sections = savedFetchedResult?.sections {
            
            if !searchingString.isEmpty {
                updateSectionForSearch()
                return searchedSections.count
            }
            
            
            
            return sections.count
            
            
        }
        
        return 0
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = savedFetchedResult?.sections {
            
            
            if(searchingString.isEmpty && !openedSections[section]) {
                return 0
            }
            
            
            
            
            let currentSection = sections[section]
            
            
            if !searchingString.isEmpty {
                let curent = searchedSections[section]
                
                let obj = (curent.objects)!
                
                return filterSearchArray(obj).count
            }
            
            
            
            
            
            return currentSection.numberOfObjects
            
            
            
        }
        
        return 0
    }
    
    public func getSection(section: Int) -> NSFetchedResultsSectionInfo? {
        if let sections = savedFetchedResult?.sections {
            
            if !searchingString.isEmpty {
                return searchedSections[section]
            }
            
            
            return sections[section]
        }
        return nil
    }
    
    
    
    public func updateSectionForSearch() {
        
        searchedSections = (savedFetchedResult?.sections)!
        
        if let sections = savedFetchedResult?.sections {
            for section in sections {
                
                let filteredArray = filterSearchArray(section.objects!)
                if filteredArray.count == 0 {
                    searchedSections.removeObject(section)
                }
            }
            
        }
    }
    
    
    
    
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        schedulerTableView.reloadData()
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        schedulerTableView.searchBar.resignFirstResponder()
    }
    
    
    public func callBack(fetchedResult :NSFetchedResultsController?, error :TalksStoreError?) {
        savedFetchedResult = fetchedResult
        if let sections = fetchedResult!.sections {
            for _ in sections {
                openedSections.append(true)
            }
        }
        schedulerTableView.reloadData()
    }
    
    
    public func fetchAll() {
        talkService.fetchTalksByTrackId(self.currentTrack, completionHandler: self.callBack)
    }
    
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 130
    }
    
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
    
    
    
    
}