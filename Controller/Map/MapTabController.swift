//
//  MapTabController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-18.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit

public class MapTabController : UIViewController {
    
    var seg:UISegmentedControl!
    var currentView : UIView?
    var accessView:UIView!
    
    let floorService = FloorService.sharedInstance
    
    var floors:[Floor]!
    
    func setupSegments() {
        floorService.fetchFloors(callBack)
    }
    
    
    func callBack(floors : [Floor], error : FloorStoreError?) {
        self.floors = floors
        for floor in floors {
            seg.insertSegmentWithTitle(floor.title, atIndex: seg.numberOfSegments, animated: false)
            APIReloadManager.fetchImg(floor.img, id: floor.objectID, service : floorService, completedAction: completed)
        }
    }
    
    func completed(msg : String) {
        //print("fetch img")
        change(seg)
    }
    
    override public func viewDidLoad() {
        
        
        seg = UISegmentedControl()
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.insertSegmentWithTitle("Venue map", atIndex: 0, animated: false)
        
        navigationController?.navigationBar.translucent = false
        
        setupSegments()
        
        seg.addTarget(self, action: Selector("change:"), forControlEvents: .ValueChanged)
        
        seg.tintColor = ColorManager.topNavigationBarColor
        
        
        
        accessView = UIView()
        accessView.translatesAutoresizingMaskIntoConstraints = false
        
        currentView?.removeFromSuperview()
     
        currentView = UIView()
        accessView.addSubview(currentView!)
        
        self.view.addSubview(seg)
        self.view.addSubview(accessView)
        
        
        self.navigationItem.title = CfpService.sharedInstance.getAdress()
        
        
            
        
        
        
        
        let viewDictionary = ["seg":seg, "accessView":accessView]
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[seg]-10-|", options: layout, metrics: nil, views: viewDictionary)
        
        let horizontalContraint1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[accessView]-0-|", options: layout, metrics: nil, views: viewDictionary)
        
        let verticalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[seg(30)]-10-[accessView]-0-|", options: layout, metrics: nil, views: viewDictionary)
        
        
        view.addConstraints(horizontalContraint0)
        view.addConstraints(horizontalContraint1)
        view.addConstraints(verticalContraint0)
        
        
        seg.selectedSegmentIndex = 0
        
        view.layoutIfNeeded()
        
        
        segZero()

        
        
        
        
        
        
    }
    
    func change(sender : UISegmentedControl) {
       
        
        if(sender.selectedSegmentIndex == 0) {
            segZero()
        }
        
        if(sender.selectedSegmentIndex > 0) {

            let currentFloor = floors[sender.selectedSegmentIndex - 1]
        
            currentView?.removeFromSuperview()
            let v = UIImageView(frame: CGRectMake(0, 0, accessView.frame.width, accessView.frame.height))
            v.image = UIImage(data: currentFloor.imgData)
            currentView = v
            accessView.addSubview(currentView!)
        }
    }
    
  
    func segZero() {
        currentView?.removeFromSuperview()
        let controller = MapController()
        controller.view.frame = CGRectMake(0, 0, accessView.frame.width, accessView.frame.height)
        currentView = controller.view
        controller.reset()
        accessView.addSubview(currentView!)
    }
}
