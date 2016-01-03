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

public class SchedulerTableViewController: UIViewController, NSFetchedResultsControllerDelegate, ScheduleViewCellDelegate, DevoxxAppFavoriteDelegate, SwitchableProtocol, FilterableTableProtocol, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var index:NSInteger = 0
    
    var searchPredicates = [String : [NSPredicate]]()
  
    var navigationItemParam:UINavigationItem!
    
    var tableView = UITableView()
    
    var isFavorite = false
    var searchingString = ""
    
    var areFilterOpened = false
    
    var currentFilters:[String : [Attribute]]?
    
    var favoriteSections = [NSFetchedResultsSectionInfo]()
    var searchedSections = [NSFetchedResultsSectionInfo]()
    
    var searchBar:UISearchBar?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        let sortTime = NSSortDescriptor(key: "fromTime", ascending: true)
        let sortAlpha = NSSortDescriptor(key: "talk.title", ascending: true)
        
        //var lastDragged : ScheduleViewCell!
        
        fetchRequest.sortDescriptors = [sortTime, sortAlpha]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "day = %@", APIManager.getDayFromIndex(self.index))
        fetchRequest.predicate = predicate

        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "fromTime",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    
    public func performSwitch() {
        if isFavorite {
            tableView.tableHeaderView = nil
        }
        else {
            tableView.tableHeaderView = searchBar
        }
        searchingString = ""
        fetchAll()
    }
    
    public func updateSwitch(switchValue: Bool) {
        isFavorite = switchValue
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        
        //let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(okok.tabBar.frame), 0);
        //self.tableView.contentInset = adjustForTabbarInsets;
        //self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
       
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
  
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        
        //view.addSubview(tableView)
               

        
        
        
        self.view.addSubview(tableView)
        
        let viewDictionnary = ["tableView": self.tableView]

        
        let verticalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionnary)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionnary)
        
        
        view.addConstraints(horizontalContraint)
        view.addConstraints(verticalContraint)
        
        
        searchBar = UISearchBar(frame: CGRectMake(0,0,44,44))
        searchBar?.delegate = self
        tableView.tableHeaderView = searchBar
        
        
        
    }
    
    
    public func fetchAll() {
        
       

        var andPredicate = [NSPredicate]()
        let predicateDay = NSPredicate(format: "day = %@", APIManager.getDayFromIndex(self.index))
        
        andPredicate.append(predicateDay)
        
        var attributeOrPredicate = [NSPredicate]()
        
        for name in searchPredicates.keys {
            attributeOrPredicate.append(NSCompoundPredicate(orPredicateWithSubpredicates: searchPredicates[name]!))
        }
        
        andPredicate.append(NSCompoundPredicate(andPredicateWithSubpredicates: attributeOrPredicate))
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
        
        //print(fetchedResultsController.fetchRequest.predicate)
        
        
        //fetchedResultsController.fetchRequest.predicate = predicateDay
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
        //first, loading from cache
        fetchAll()
        //then try to retrieve the potential updates
        //let slotHelper = SlotHelper()
        //APIManager.getMockedObjets(postActionParam: fetchAll, dataHelper: slotHelper)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if let slot = getCell(indexPath) as? Slot {
                
            let details = TalkDetailsController()
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
            cellDataTry = fetchedResultsController.objectAtIndexPath(indexPath) as? CellDataPrococol
        }
        return cellDataTry
    }
    
    
    
    
    public func getTintColorFromTag(tag : Int) -> UIColor {
        if tag == 0  {
            return UIColor.blackColor()
        }
        return UIColor.whiteColor()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10") as? ScheduleViewCell
        
            
        if cell == nil {
            cell = ScheduleViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .None
            cell?.delegate = self
            cell!.configureCell()
        }
        
        
        
        
        
        if let cellData = getCell(indexPath) {
            //cell!.trackImg.image = 
            
            cell!.trackImg.image = cellData.getPrimaryImage()
            
            cell!.talkTitle.text = cellData.getFirstInformation()
            cell!.talkRoom.text = cellData.getSecondInformation()
            cell!.talkType.text = cellData.getThirdInformation()
            cell!.talkType.backgroundColor = cellData.getColor()

            if let fav = cellData as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.favorited())
            }
            
        } else {
            // should be be here
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

        if let sections = fetchedResultsController.sections {
            
            if !searchingString.isEmpty {
                updateSectionForSearch()
                return searchedSections.count
            }
            
            
            if !isFavorite {
                //print("sectionCount = \(sections.count)")
                return sections.count
            }
            
            updateSection()
            return favoriteSections.count
            
        }
        
        return 0
    }
    
       
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            
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
        if let sections = fetchedResultsController.sections {
            
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
        
        favoriteSections = fetchedResultsController.sections!

        if let sections = fetchedResultsController.sections {
            for section in sections {
                
                let filteredArray = filterArray(section.objects!)
                if filteredArray.count == 0 {
                    favoriteSections.removeObject(section)
                }
            }
            
        }
    }
    
    
    public func updateSectionForSearch() {
        
        searchedSections = fetchedResultsController.sections!
        
        if let sections = fetchedResultsController.sections {
            for section in sections {
                
                let filteredArray = filterSearchArray(section.objects!)
                if filteredArray.count == 0 {
                    searchedSections.removeObject(section)
                }
            }
            
        }
    }
  
    
    public func changeSchedule(sender: UISegmentedControl) {
        self.hideAllFavorite(except:nil, animated: false)
        self.fetchAll()
    }
    
    
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
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
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    
    public func favorite(indexPath : NSIndexPath) -> Bool {
        if let cellData = fetchedResultsController.objectAtIndexPath(indexPath) as? CellDataPrococol {
            if let cellElement = cellData as? FavoriteProtocol  {
                return cellElement.invertFavorite()
            }
        }
        return false
    }
    
    
    func filter() {
        fetchAll()
    }
    
    func buildFilter(filters: [String : [Attribute]]) {
        currentFilters = filters
        for key in filters.keys {
            searchPredicates[key] = [NSPredicate]()
            for attribute in filters[key]! {
                let predicate = NSPredicate(format: "\(attribute.filterPredicateLeftValue()) = %@", attribute.filterPredicateRightValue())
                searchPredicates[key]?.append(predicate)
            }
        }
    }
    
    func clearFilter() {
        searchPredicates.removeAll()
    }
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        self.tableView.reloadData()
    }
    
    func getCurrentFilters() -> [String : [Attribute]]? {
        return currentFilters
    }
    
    
       
}