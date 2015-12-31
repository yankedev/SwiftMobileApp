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
    func getNavigationController() -> UINavigationController?
}

public protocol DevoxxAppFavoriteDelegate : NSObjectProtocol {
    func favorite(path : NSIndexPath) -> Bool
}

public class SchedulerTableViewController: UIViewController, NSFetchedResultsControllerDelegate, ScheduleViewCellDelegate, DevoxxAppFavoriteDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var delegate:DevoxxAppScheduleDelegate!
    
    var searchPredicates = [NSPredicate]()
  
    var navigationItemParam:UINavigationItem!
    
    var tableView = UITableView()
    
    var isFavorite = false
    
    var favoriteSections = [NSFetchedResultsSectionInfo]()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Slot")
        let sortTime = NSSortDescriptor(key: "fromTime", ascending: true)
        let sortAlpha = NSSortDescriptor(key: "talk.title", ascending: true)
        
        //var lastDragged : ScheduleViewCell!
        
        fetchRequest.sortDescriptors = [sortTime, sortAlpha]
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
        
        
     
      
        
        
        self.view.addSubview(tableView)
    
        
        
        
        //let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(okok.tabBar.frame), 0);
        //self.tableView.contentInset = adjustForTabbarInsets;
        //self.tableView.scrollIndicatorInsets = adjustForTabbarInsets;
       
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //let verticalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]-\(self.tabBarController?.tabBar.frame.height)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)

        
        //view.addConstraints(horizontalContraint)
        //view.addConstraints(verticalContraint)
        
        //self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.tableView.separatorStyle = .None
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchSchedule"))
        searchButton.tintColor = UIColor.whiteColor()
        
        
        
        //view.addSubview(tableView)
               

        
        
        
        
        
        
    }
    
    
    public func fetchAll() {

        var andPredicate = [NSPredicate]()
        let predicateDay = NSPredicate(format: "day = %@", APIManager.getDayFromIndex(self.view.tag))
        
        var orPredicate = NSPredicate(value: true)
        if(searchPredicates.count > 0) {
            orPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchPredicates)
        }
        andPredicate.append(orPredicate)
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: andPredicate)
        fetchedResultsController.fetchRequest.predicate = predicateDay
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
        let slotHelper = SlotHelper()
        APIManager.getMockedObjets(postActionParam: fetchAll, dataHelper: slotHelper)
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
    
    
    
    func getCell(indexPath : NSIndexPath) -> CellData? {
        var cellDataTry:CellData?
        if isFavorite {
            let curent = favoriteSections[indexPath.section]
            let obj = (curent.objects)!
            cellDataTry = filterArray(obj)[indexPath.row] as? CellData
        }
        else {
            cellDataTry = fetchedResultsController.objectAtIndexPath(indexPath) as? CellData
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
    /*
    func filterArrayOffset(offset : Int, currentArray : [AnyObject]) -> [AnyObject] {
        
        var index = 0
        
        for subArray in currentArray {
            
        }
        
        return filteredArray
        
    }
*/
    
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        if let sections = fetchedResultsController.sections {
            if !isFavorite {
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
        return 50.0
    }
    
    
    public func favorite(indexPath : NSIndexPath) -> Bool {
        if let cellData = fetchedResultsController.objectAtIndexPath(indexPath) as? CellData {
            if let cellElement = cellData as? FavoriteProtocol  {
                return cellElement.invertFavorite()
            }
        }
        return false
    }
    
    
       
}