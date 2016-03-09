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


public class TrackTableViewController:
    UIViewController,
    FilterableTableDataSource,
    UITableViewDelegate,
    SearchableTableProtocol,
    UITableViewDataSource,
    UISearchBarDelegate,
    ScrollableDateProtocol
{
    
    public func hi() {
       // print("hi")
    }
    
    var sortedSlot:[Slot]!
    
    //ScrollableDateProtocol
    public var index:Int = 0
    public var currentTrack:String!
    public var currentDate:NSDate!
    
    public func getNavigationItem() -> UINavigationItem {
        return (self.navigationController?.navigationItem)!
    }
    
    
    var openedSections = [Bool]()
    
    
    
    //SerchableTableProtocol
    var searchPredicates = [String : [NSPredicate]]()
    var searchingString = ""
    
    var searchedSections = [NSFetchedResultsSectionInfo]()
    
    
    //FilterableTableDataSource
    var frc:NSFetchedResultsController?
    
    var filterableTableDataSource: FilterableTableDataSource!
    
    var schedulerTableView = SchedulerTableView()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        filterableTableDataSource = self
        
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
        let predicateDay = NSPredicate(format: "talk.track = %@", self.currentTrack)
        let predicateEvent = NSPredicate(format: "eventId = %@", APIManager.currentEvent.id!)
        
        andPredicate.append(predicateDay)
        andPredicate.append(predicateEvent)
        
        var attributeOrPredicate = [NSPredicate]()
        
        for name in searchPredicates.keys {
            attributeOrPredicate.append(NSCompoundPredicate(orPredicateWithSubpredicates: searchPredicates[name]!))
        }
        
        andPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: attributeOrPredicate))
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
    }
    
    public func fetchAll() {
        fetchedResultsController().fetchRequest.predicate = computePredicate()
        
        do {
            try fetchedResultsController().performFetch()
        } catch let error as NSError {
            //todo
           // print("unresolved error \(error), \(error.userInfo)")
        }
        
        if let sections = frc?.sections {
            for _ in sections {
                openedSections.append(true)
            }
        }
        
        schedulerTableView.reloadData()
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
        
        if let slot = getCell(indexPath) as? Slot {
            
            let details = TalkDetailsController()
            //todo
            //details.indexPath = indexPath
            details.slot = slot
            
            
            
            details.configure()
            
            details.setColor(slot.favorited())
            
            self.navigationController?.pushViewController(details, animated: true)
            
            
        }
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
            cellDataTry = frc?.objectAtIndexPath(indexPath) as? CellDataPrococol
            
            let slot = frc?.sections![indexPath.section].objects as? [Slot]
            if sortedSlot == nil {
                sortedSlot = slot?.sort({ $0.favorited() > $1.favorited() })
            }

            return slot![indexPath.row]
        }
        return nil
        
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
                cell!.updateBackgroundColor(fav.favorited())
            }
                
            return cell!
                
        } else {
                // todo should be be here
        }
        
        return UITableViewCell()
    }

    
    func filterArray(currentArray : [AnyObject]) -> [AnyObject] {
        
        let filteredArray = currentArray.filter() {
            if let type = $0 as? FavoriteProtocol {
                return type.favorited()
            } else {
                return false
            }
        }
        
        return filteredArray
        
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
        
        if let sections = frc?.sections {
            
            if !searchingString.isEmpty {
                updateSectionForSearch()
                return searchedSections.count
            }
            
            
            
            return sections.count
            
            
        }
        
        return 0
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = frc?.sections {
            
            
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
        if let sections = frc?.sections {
            
            if !searchingString.isEmpty {
                return searchedSections[section]
            }
            
            
            return sections[section]
        }
        return nil
    }
    
    
    
    public func updateSectionForSearch() {
        
        searchedSections = (frc?.sections)!
        
        if let sections = frc?.sections {
            for section in sections {
                
                let filteredArray = filterSearchArray(section.objects!)
                if filteredArray.count == 0 {
                    searchedSections.removeObject(section)
                }
            }
            
        }
    }
    
    
    public func favorite(indexPath : NSIndexPath) -> Bool {
        if let cellData = frc?.objectAtIndexPath(indexPath) as? CellDataPrococol {
            if let cellElement = cellData as? FavoriteProtocol  {
                return cellElement.invertFavorite()
            }
        }
        return false
    }
    
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        schedulerTableView.reloadData()
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        schedulerTableView.searchBar.resignFirstResponder()
    }
    
    
    //FilterableTableDataSource
    
    func fetchedResultsController() -> NSFetchedResultsController {
        
        if frc != nil {
            return frc!
        }
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        let sortTime = NSSortDescriptor(key: "fromTime", ascending: true)
        let sortAlpha = NSSortDescriptor(key: "talk.title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortTime, sortAlpha,]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "talk.track = %@", self.currentTrack)
        fetchRequest.predicate = predicate
        
        frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "talk.track",
            cacheName: nil)
        
        return frc!
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