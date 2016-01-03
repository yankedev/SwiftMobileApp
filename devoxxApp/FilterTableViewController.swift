//
//  FilterTableViewController.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-20.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import QuartzCore


protocol DevoxxAppFilter : NSObjectProtocol {
    func filter(filterName : [String : [Attribute]]) -> Void
}


extension Array {
    
    mutating func removeObject<U: AnyObject>(object: U) -> Element? {
        if count > 0 {
            for index in startIndex ..< endIndex {
                if (self[index] as! U) === object { return self.removeAtIndex(index) }
            }
        }
        return nil
    }
}


public class FilterTableViewController: UIView, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableView = UITableView()
    
    var selected = [String : [Attribute]]()
    
    var devoxxAppFilterDelegate:DevoxxAppFilter?
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Attribute")
        let sortSection = NSSortDescriptor(key: "type", ascending: true)
        let sortAlpha = NSSortDescriptor(key: "label", ascending: true)
        
        fetchRequest.sortDescriptors = [sortSection, sortAlpha]
        fetchRequest.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: "type",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    public func fetchAll() {
        
        var error: NSError? = nil
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("unresolved error \(error), \(error!.userInfo)")
        }
        tableView.reloadData()
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = ColorManager.filterBackgroundColor
        backgroundColor = ColorManager.bottomDotsPageController

/*
        let trackHelper = TrackHelper()
        APIManager.getMockedObjets(postActionParam: fetchAll, dataHelper: trackHelper)
        
        let talkTypeHelper = TalkTypeHelper()
        APIManager.getMockedObjets(postActionParam: fetchAll, dataHelper: talkTypeHelper)
        */
        
        fetchAll()
     
    }
    
    
    func isFilterSelected(attribute : Attribute) -> Bool {
        if selected[attribute.filterPredicateLeftValue()] == nil  {
            return false
        }
        if selected[attribute.filterPredicateLeftValue()]!.contains(attribute) {
            return true
        }
        return false
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let track = fetchedResultsController.objectAtIndexPath(indexPath) as? Attribute {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! FilterViewCell
            
            
            
            cell.userInteractionEnabled = false
            
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseOut, animations: {
                
                let scale = CGAffineTransformMakeScale(0.1, 0.1)
                let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                
          
                
                cell.tickedImg.transform = CGAffineTransformConcat(rotate, scale)
                }, completion: { finished in
                    
                    
                    let imageToUse = (self.isFilterSelected(track)) ? "checkboxOff" : "checkboxOn"
                    
                    cell.tickedImg.image = UIImage(named: imageToUse)
                    let scale = CGAffineTransformMakeScale(0.1, 0.1)
                    let rotate = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
                    cell.tickedImg.transform = CGAffineTransformConcat(rotate, scale)

                    
                    UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseOut, animations: {
                        
                        let scale = CGAffineTransformMakeScale(1, 1)
                        let rotate = CGAffineTransformMakeRotation(CGFloat(0))
                        
                        CGAffineTransformConcat(rotate, scale)
                        
                        cell.tickedImg.transform = CGAffineTransformConcat(rotate, scale)
                        }, completion: { finished in
                            
                           
                            let key = track.filterPredicateLeftValue()
                            
                            if self.selected[key] != nil  {
                                if self.selected[key]!.contains(track) {
                                    self.selected[key]!.removeObject(track)
                                    if self.selected[key]!.count == 0 {
                                        self.selected.removeValueForKey(key)
                                    }
                                    cell.backgroundColor = ColorManager.defaultColor
                                }
                                else {
                                    self.selected[key]!.append(track)
                                }
                            }
                                
                            else {
                                var attributeArray = [Attribute]()
                                attributeArray.append(track)
                                self.selected[key] = attributeArray
                            }
                            
                            cell.userInteractionEnabled = true
                           
                            self.devoxxAppFilterDelegate?.filter(self.selected)
                            
                    
                            
                        }
                    )

                    
            }
            )
            
        }
        
        
        
       
    }

    
   
    


    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_1") as? FilterViewCell
        
        
        if cell == nil {
            cell = FilterViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .None
            cell?.configureCell()
        }
        
        if let attribute = fetchedResultsController.objectAtIndexPath(indexPath) as? Attribute {
            cell?.attributeTitle.text = attribute.label
            cell?.attributeImage.image = attribute.filterMiniIcon()
            
            
            
            
            
            cell?.backgroundColor = ColorManager.defaultColor
            
            let imageToUse = (isFilterSelected(attribute)) ? "checkboxOn" : "checkboxOff"
            cell?.tickedImg.image = UIImage(named: imageToUse)
            
        }
        return cell!
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
   
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            if currentSection.objects?.count > 0 {
                if let currentSectionFilterable = currentSection.objects![0] as? FilterableProtocol {
                    return currentSectionFilterable.niceLabel()
                }
            }
        }
        return nil
    }
    
}