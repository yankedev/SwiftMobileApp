///
//  SchedulerTableViewController.swift
//  devoxxApp
//
//  Created by maxday on 09.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData


open class SchedulerTableViewController<T : CellDataPrococol>:
    UIViewController,
    FavoritableProtocol,
    FilterableTableProtocol,
    UITableViewDelegate,
    SearchableTableProtocol,
    UITableViewDataSource,
    UISearchBarDelegate,
    ScrollableDateProtocol,
    HotReloadProtocol
{
    
    
    //ScrollableDateProtocol
    open var index:Int = 0
    open var currentTrack:NSManagedObjectID!
    open var currentDate:Date!
    
    open func getNavigationItem() -> UINavigationItem {
        return (self.navigationController?.navigationItem)!
    }
    
    
    
    
    var openedSections = [Bool]()
    
    
    
    //SerchableTableProtocol
    var searchPredicates = [String : [NSPredicate]]()
    var searchingString = ""
    
    var searchedSections = [NSFetchedResultsSectionInfo]()
    
    
    
    //FilterableTableProtocol
    var currentFilters:[String : [FilterableProtocol]]!
    
    
    var schedulerTableView = SchedulerTableView()
    
    
    var savedFetchedResult : NSFetchedResultsController<NSFetchRequestResult>?
    
    public required init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUpdate()

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
        fetchUpdate()
        self.schedulerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //sync with watch
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name:NSNotification.Name(rawValue: "UpdateFavorite"), object: nil)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateFavorite"), object: nil)
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
        TalkService.sharedInstance.fetchTalksByDate(self.currentDate, searchPredicates : self.searchPredicates, completionHandler: self.callBack)
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
        
        if let slot = getCell(indexPath) as? HelperableProtocol {
    
            let details = TalkDetailsController()
            //todo
            
            details.detailObject = slot.toHelper() as? DetailableProtocol
       
            
            details.delegate = self
    
            details.configure()
            
            
            if let slotFavorite = slot as? FavoriteProtocol {
                details.setColor(slotFavorite.isFav())
            }
            
            //details.setColor(slot.talk.isFavorited)
            
            self.navigationController?.pushViewController(details, animated: true)
            
            
        }

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
        
        let cellData = getCell(indexPath)
        
        if cellData?.isSpecial() == true {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "BREAK_CELL") as? ScheduleBreakCell
            
            if cell == nil {
                cell = ScheduleBreakCell(style: UITableViewCellStyle.value1, reuseIdentifier: "BREAK_CELL")
            }
            
            cell?.rightTextView.text = cellData?.getFirstInformation()
            
            cell?.leftIconView.setup()
            
            cell?.leftIconView.imageView.frame = CGRect(x: 0, y: 5, width: 50, height: 60).insetBy(dx: 8, dy: 8);
            cell?.leftIconView.imageView.contentMode = .scaleAspectFit
            
            cell?.leftIconView.imageView.image = UIImage(named: "cofeeCup.png")
            
            cell?.backgroundColor = cellData!.getColor()
            
            
            return cell!
            
        }
        else {
            
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
    
    
    
    
    
    
    open func favorite(_ id : NSManagedObjectID) -> Bool {
        return TalkService.sharedInstance.invertFavorite(id)
    }
    
    
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingString = searchText
        schedulerTableView.reloadData()
    }
    
    //FilterableTableDataSource
    
    //FilterableTableProtocol
    
    
    func clearFilter() {
        searchPredicates.removeAll()
    }
    
    
    func buildFilter(_ filters: [String : [FilterableProtocol]]) {
        currentFilters = filters
        for key in filters.keys {
            searchPredicates[key] = [NSPredicate]()
            for attribute in filters[key]! {
                let predicate = NSPredicate(format: "\(attribute.filterPredicateLeftValue()) != %@", attribute.filterPredicateRightValue())
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
    
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        /*if let sections = frc?.sections {
        let currentSection = sections[section]
        if currentSection.numberOfObjects == 1 {
        return 0
        }
        }*/
        return 44
        
        
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let cellData = getCell(indexPath)
        
        if cellData?.isSpecial() == true {
            return 60
        }
        
        
        
        return 130
    }
    
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title = ""
        var nbTalks = 0
        
        var set = Set<String>()
        
        let currentSection = getSection(section)!
        
        
        var obj = currentSection.objects!
        if !searchingString.isEmpty {
            obj = filterSearchArray(obj as [AnyObject])
        }
        
        if let talk = obj[0] as? Talk {
            title = "\(currentSection.name) - \(talk.slot.toTime)"
        }
        nbTalks = obj.count
        for talk in obj {
            if let currentTalk = talk as? Talk {
                set.insert(currentTalk.track)
            }
        }
        
        
        
        let breakSlot = (set.count == 1 && set.first == "")
        
        let headerView = HeaderView(frame: CGRect(x: 0,y: 0,width: schedulerTableView.frame.width, height: 50))
        headerView.headerString.text = title
        
        
        headerView.tag = section
        headerView.upDown.tag = section
        headerView.upDown.addTarget(self, action: #selector(self.openCloseButton(_:)), for: .touchUpInside)
        headerView.upDown.isSelected = openedSections[section]
        
        if breakSlot {
            headerView.upDown.isHidden = breakSlot
            headerView.eventImg.isHidden = breakSlot
            headerView.numberOfTalkString.text = ""
            headerView.backgroundColor = ColorManager.breakColor
        }
        else {
            let pluralTracks = (set.count > 1) ? "tracks" : "track"
            let pluralTalks = (nbTalks > 1) ? "talks" : "talk"
            
            headerView.numberOfTalkString.text = "\(nbTalks) \(pluralTalks) in \(set.count) \(pluralTracks)"
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.openCloseView(_:)))
            headerView.addGestureRecognizer(tap)
        }
        
        
        return headerView
    }
    
    
    func openCloseButton(_ sender: UIButton) {
        let indexPath : IndexPath = IndexPath(row: 0, section:(sender.tag as Int!)!)
        if (indexPath.row == 0) {
            
            openedSections[indexPath.section] =  !openedSections[indexPath.section]
            
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = IndexSet(integersIn: range.toRange() ?? 0..<0)
            self.schedulerTableView .reloadSections(sectionToReload, with:UITableViewRowAnimation.fade)
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    func openCloseView(_ sender: UITapGestureRecognizer) {
        let indexPath : IndexPath = IndexPath(row: 0, section:(sender.view!.tag as Int!)!)
        if (indexPath.row == 0) {
            
            openedSections[indexPath.section] =  !openedSections[indexPath.section]
            
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = IndexSet(integersIn: range.toRange() ?? 0..<0)
            self.schedulerTableView .reloadSections(sectionToReload, with:UITableViewRowAnimation.fade)
        }
        
        if let view = sender.view as? HeaderView {
            view.upDown.isSelected = !view.upDown.isSelected
        }
        
    }
    
    open func fetchUpdate() {
        APIReloadManager.fetchUpdate(fetchUrl(), service: SlotService.sharedInstance, completedAction: fetchCompleted)
    }
    
    open func fetchCompleted(_ newHelper : CallbackProtocol) -> Void {
        fetchAll()
    }

    
    open func fetchUrl() -> String? {
        return CfpService.sharedInstance.getDayUrl(index)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        schedulerTableView.searchBar.resignFirstResponder()
    }
    
    
    func handleNotification(_ notification: Notification){
        schedulerTableView.reloadData()
    }
    
    
    
}
