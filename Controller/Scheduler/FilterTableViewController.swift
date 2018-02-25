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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



protocol DevoxxAppFilter : NSObjectProtocol {
    func filter(_ filterName : [String : [FilterableProtocol]]) -> Void
}



extension Array {
    
    mutating func removeObject<U: AnyObject>(_ object: U) -> Element? {
        if count > 0 {
            for index in startIndex ..< endIndex {
                if (self[index] as! U) === object { return self.remove(at: index) }
            }
        }
        return nil
    }
}


open class FilterTableViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    var filterTableView = FilterTableView()
    
    var selected = [String : [FilterableProtocol]]()
    
    var devoxxAppFilterDelegate:DevoxxAppFilter?
    
    var savedFetchedResult:NSFetchedResultsController<NSFetchRequestResult>!
    
    open func callBack(_ fetchedResult :NSFetchedResultsController<NSFetchRequestResult>?, error :AttributeStoreError?) {
        savedFetchedResult = fetchedResult
        filterTableView.reloadData()
    }
    
    
    open func fetchAll() {
        AttributeService.sharedInstance.fetchFilters(self.callBack)
    }

    
    
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        self.view.addSubview(filterTableView)
        
        
        self.view.backgroundColor = ColorManager.bottomDotsPageController
        
        fetchAll()
    }
    
    
    func isFilterSelected(_ attribute : FilterableProtocol) -> Bool {
        if selected[attribute.filterPredicateLeftValue()] == nil  {
            return false
        }
        
        
        if let array = selected[attribute.filterPredicateLeftValue()] {
            for item in array {
                if item.filterPredicateLeftValue() == attribute.filterPredicateLeftValue() &&
                    item.filterPredicateRightValue() == attribute.filterPredicateRightValue() {
                        return true
                }
            }
        }
        
        return false
    }
    
    
    
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let track = savedFetchedResult.object(at: indexPath) as? Attribute {
            let cell = tableView.cellForRow(at: indexPath) as! FilterViewCell
            
            
            
            cell.isUserInteractionEnabled = false
            
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                
                let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
                let rotate = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
                
                
                
                cell.tickedImg.transform = rotate.concatenating(scale)
                }, completion: { finished in
                    
                    
                    let imageToUse = (self.isFilterSelected(track)) ? "checkboxOn" : "checkboxOff"
                    
                    cell.tickedImg.image = UIImage(named: imageToUse)
                    let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    let rotate = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
                    cell.tickedImg.transform = rotate.concatenating(scale)
                    
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                        
                        let scale = CGAffineTransform(scaleX: 1, y: 1)
                        let rotate = CGAffineTransform(rotationAngle: CGFloat(0))
                        
                        rotate.concatenating(scale)
                        
                        cell.tickedImg.transform = rotate.concatenating(scale)
                        }, completion: { finished in
                            
                            
                            let key = track.filterPredicateLeftValue()
                            
                            
                            if let array = self.selected[key]  {
                                var contains = false
                                
                                for item in array {
                                    if item.filterPredicateLeftValue() == track.filterPredicateLeftValue() && item.filterPredicateRightValue() == track.filterPredicateRightValue() {
                                        contains = true
                                        break
                                    }
                                }
                                
                                if contains {
                                    self.selected[key]!.removeObject(track)
                                    if self.selected[key]!.count == 0 {
                                        self.selected.removeValue(forKey: key)
                                    }
                                    cell.backgroundColor = ColorManager.defaultColor
                                }
                                else {
                                    self.selected[key]!.append(track)
                                }
                                
                            }
                            else {
                                var attributeArray = [FilterableProtocol]()
                                attributeArray.append(track)
                                self.selected[key] = attributeArray
                            }
                            
                            cell.isUserInteractionEnabled = true
                            
                            self.devoxxAppFilterDelegate?.filter(self.selected)
                            
                            
                            
                        }
                    )
                    
                    
                }
            )
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_1") as? FilterViewCell
        
        
        if cell == nil {
            cell = FilterViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL_1")
            cell?.selectionStyle = .none
            cell?.configureCell()
        }
        
        if let attribute = savedFetchedResult?.object(at: indexPath) as? Attribute {
            cell?.attributeTitle.text = attribute.label
            cell?.attributeImage.image = attribute.filterMiniIcon()
            
            
            
            
            
            cell?.backgroundColor = ColorManager.defaultColor
            
            let imageToUse = (isFilterSelected(attribute)) ? "checkboxOff" : "checkboxOn"
            cell?.tickedImg.image = UIImage(named: imageToUse)
            
        }
        return cell!
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = savedFetchedResult?.sections {
            return sections.count
        }
        
        return 0
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = savedFetchedResult?.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = savedFetchedResult?.sections {
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
