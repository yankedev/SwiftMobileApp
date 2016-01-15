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

public protocol DevoxxAppFavoriteDelegate : NSObjectProtocol {
    func favorite(path : NSIndexPath) -> Bool
}

public class SchedulerTableViewController:
        UIViewController,
        DevoxxAppFavoriteDelegate,
        SwitchableProtocol,
        FilterableTableDataSource,
        FilterableTableProtocol,
        ScrollableTableProtocol,
        UITableViewDelegate,
        SearchableTableProtocol,
        UITableViewDataSource,
        UISearchBarDelegate {
    
    //ScrollableProtocol
    var index:NSInteger = 0
    var currentDate:NSDate!
    
    
    //SerchableTableProtocol
    var searchPredicates = [String : [NSPredicate]]()
    var searchingString = ""
    
    var searchedSections = [NSFetchedResultsSectionInfo]()
    
    
    //FavoriteTableProtocol
    var isFavorite = false
    var favoriteSections = [NSFetchedResultsSectionInfo]()
    
    //FilterableTableProtocol
    var currentFilters:[String : [FilterableProtocol]]!
    
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
    }

    
    private func computePredicate() -> NSPredicate {
        var andPredicate = [NSPredicate]()
        let predicateDay = NSPredicate(format: "date = %@", self.currentDate)
        
        andPredicate.append(predicateDay)
        
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
            print("unresolved error \(error), \(error.userInfo)")
        }
        schedulerTableView.reloadData()
    }
    
    public func resetSearch() {
        searchingString = ""
    }
    
    public func performSwitch() {
        schedulerTableView.updateHeaderView(!isFavorite)
        resetSearch()
        fetchAll()
    }
    
    public func updateSwitch(switchValue: Bool) {
        isFavorite = switchValue
    }
    
    
    
    //TableView

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if let slot = getCell(indexPath) as? Slot {
                
            let details = TalkDetailsController()
            //todo
            details.indexPath = indexPath
            details.talk = slot.talk
            details.delegate = self
            details.configure()
            details.setColor(slot.talk.favorited())
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
        
        if isFavorite {
            let curent = favoriteSections[indexPath.section]
            let obj = (curent.objects)!
            cellDataTry = filterArray(obj)[indexPath.row] as? CellDataPrococol
        }
        else {
            cellDataTry = frc?.objectAtIndexPath(indexPath) as? CellDataPrococol
        }
        return cellDataTry
    }
    
 
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10") as? ScheduleViewCell
        
    
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .None
            cell!.configureCell()
        }

        if let cellData = getCell(indexPath) {

            cell!.trackImg.image = cellData.getPrimaryImage()
            
            cell!.talkTitle.text = cellData.getFirstInformation()
            cell!.talkRoom.text = cellData.getSecondInformation()
            cell!.talkType.text = cellData.getThirdInformation()
            cell!.talkType.backgroundColor = cellData.getColor()

            if let fav = cellData as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.favorited())
            }
            
        } else {
            // todo should be be here
        }
        
            
        return cell!
        
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
            if let type = $0 as? SearchableProcotol {
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
            
            
            if !isFavorite {
                return sections.count
            }
            
            updateSection()
            return favoriteSections.count
            
        }
        
        return 0
    }
    
       
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = frc?.sections {
            
            let currentSection = sections[section]
            
            
            if !searchingString.isEmpty {
                let curent = searchedSections[section]
             
                let obj = (curent.objects)!
             
                return filterSearchArray(obj).count
            }
            
            
            
            
            if !isFavorite {
                return currentSection.numberOfObjects
            }

            
            
            let curent = favoriteSections[section]

            
            let obj = (curent.objects)!
            

            
            
            return filterArray(obj).count
        }
        
        return 0
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = frc?.sections {
            
            if !searchingString.isEmpty {
                return searchedSections[section].name
            }
            
            if !isFavorite {
                return sections[section].name
            }
            return favoriteSections[section].name
        }
        
        return nil
    }
    
    public func updateSection() {
        
        favoriteSections = (frc?.sections)!

        if let sections = frc?.sections {
            for section in sections {
                
                let filteredArray = filterArray(section.objects!)
                if filteredArray.count == 0 {
                    favoriteSections.removeObject(section)
                }
            }
            
        }
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
  
    
    public func changeSchedule(sender: UISegmentedControl) {
        self.fetchAll()
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
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
            
        fetchRequest.sortDescriptors = [sortTime, sortAlpha]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "date = %@", self.currentDate)
        fetchRequest.predicate = predicate
            
        frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "fromTime",
            cacheName: nil)

        return frc!
    }

    //FilterableTableProtocol
    
    
    func clearFilter() {
        searchPredicates.removeAll()
    }

    
    func buildFilter(filters: [String : [FilterableProtocol]]) {
        currentFilters = filters
        for key in filters.keys {
            searchPredicates[key] = [NSPredicate]()
            for attribute in filters[key]! {
                let predicate = NSPredicate(format: "\(attribute.filterPredicateLeftValue()) = %@", attribute.filterPredicateRightValue())
                searchPredicates[key]?.append(predicate)
            }
        }
    }
    
    func filter() {
        fetchAll()
    }
    
    func getCurrentFilters() -> [String : [FilterableProtocol]]? {
        return currentFilters
    }
    

       
}