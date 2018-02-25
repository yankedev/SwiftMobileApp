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


open class TrackTableViewController<T : CellDataPrococol>:
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
    open var index:Int = 0
    open var currentTrack:NSManagedObjectID!
    open var currentDate:Date!
    
    open func getNavigationItem() -> UINavigationItem {
        return (self.navigationController?.navigationItem)!
    }
    
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var openedSections = [Bool]()
    
    
    
    //SerchableTableProtocol
    var searchPredicates = [String : [NSPredicate]]()
    var searchingString = ""
    
    var searchedSections = [NSFetchedResultsSectionInfo]()
    
    
    
    
    var schedulerTableView = SchedulerTableView()
    
    var presort = Array<[Slot]>()
    
    let talkService = TalkService.sharedInstance
    var savedFetchedResult : NSFetchedResultsController<NSFetchRequestResult>?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        schedulerTableView.delegate = self
        schedulerTableView.dataSource = self
        
        schedulerTableView.searchBar.delegate = self
        schedulerTableView.updateHeaderView(true)
        self.view.addSubview(schedulerTableView)
        schedulerTableView.setupConstraints()
    }
    
    

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        fetchAll()
        
        
        
        self.schedulerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
    
        //sync with watch
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name:NSNotification.Name(rawValue: "UpdateFavorite"), object: nil)
    }
    
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateFavorite"), object: nil)
    }

    
    
    
    
    open func resetSearch() {
        searchingString = ""
    }
    
    open func performSwitch() {
        resetSearch()
        fetchAll()
    }
    
    
    
    //TableView
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let detailObject = getCell(indexPath) as? HelperableProtocol {
            
            
            
            
            let details = TalkDetailsController()
            details.detailObject = detailObject.toHelper() as? DetailableProtocol
            details.delegate = self
            
            
            details.configure()
            
            if let favorite = detailObject as? FavoriteProtocol {
                details.setColor(favorite.isFav())
            }
            self.navigationController?.pushViewController(details, animated: true)
            
            
        }
    }
    
    
    open func favorite(_ id : NSManagedObjectID) -> Bool {
        return talkService.invertFavorite(id)
    }
    
    
    
    
    
    func getCell(_ indexPath : IndexPath) -> CellDataPrococol? {
        
        var cellDataTry:CellDataPrococol?
        
        if !searchingString.isEmpty {
            
            let curent = searchedSections[indexPath.section]
            let obj = (curent.objects)!
            cellDataTry = filterSearchArray(obj as [AnyObject])[indexPath.row] as? CellDataPrococol
            return cellDataTry
        }
            
        else {
            return savedFetchedResult?.object(at: indexPath) as? CellDataPrococol
        }
        
    }
    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_10") as? ScheduleCellView
        
        if cell == nil {
            cell = ScheduleCellView(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL_10")
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
    
    
  
    
    
    
    func filterSearchArray(_ currentArray : [AnyObject]) -> [AnyObject] {
        
        let filteredArray = currentArray.filter() {
            if let type = $0 as? SearchableItemProtocol {
                return type.isMatching(searchingString)
            } else {
                return false
            }
        }
        
        return filteredArray
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = savedFetchedResult?.sections {
            
            if !searchingString.isEmpty {
                updateSectionForSearch()
                return searchedSections.count
            }
            
            
            
            return sections.count
            
            
        }
        
        return 0
    }
    
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = savedFetchedResult?.sections {
            
            
            if(searchingString.isEmpty && !openedSections[section]) {
                return 0
            }
            
            
            
            
            let currentSection = sections[section]
            
            
            if !searchingString.isEmpty {
                let curent = searchedSections[section]
                
                let obj = (curent.objects)!
                
                return filterSearchArray(obj as [AnyObject]).count
            }
            
            
            
            
            
            return currentSection.numberOfObjects
            
            
            
        }
        
        return 0
    }
    
    open func getSection(_ section: Int) -> NSFetchedResultsSectionInfo? {
        if let sections = savedFetchedResult?.sections {
            
            if !searchingString.isEmpty {
                return searchedSections[section]
            }
            
            
            return sections[section]
        }
        return nil
    }
    
    
    
    open func updateSectionForSearch() {
        
        searchedSections = (savedFetchedResult?.sections)!
        
        if let sections = savedFetchedResult?.sections {
            for section in sections {
                
                let filteredArray = filterSearchArray(section.objects! as [AnyObject])
                if filteredArray.count == 0 {
                    searchedSections.removeObject(section)
                }
            }
            
        }
    }
    
    
    
    
    
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        schedulerTableView.reloadData()
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        schedulerTableView.searchBar.resignFirstResponder()
    }
    
    
    open func callBack(_ fetchedResult :NSFetchedResultsController<NSFetchRequestResult>?, error :TalksStoreError?) {
        savedFetchedResult = fetchedResult
        if let sections = fetchedResult!.sections {
            for _ in sections {
                openedSections.append(true)
            }
        }
        schedulerTableView.reloadData()
    }
    
    
    open func fetchAll() {
        talkService.fetchTalksByTrackId(self.currentTrack, completionHandler: self.callBack)
    }
    
    
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func handleNotification(_ notification: Notification){
        schedulerTableView.reloadData()
    }
    
    
    
    
    
    
}
