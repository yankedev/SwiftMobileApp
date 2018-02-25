//
//  MapTabController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-18.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit

open class MapTabController : UIViewController {
    
    var seg:UISegmentedControl!
    var currentView : UIView?
    var accessView:UIView!
    
    let floorService = FloorService.sharedInstance
    
    var floors:[Floor]!
    
    func setupSegments() {
        floorService.fetchFloors(callBack)
    }
    
    
    func callBack(_ floors : [Floor], error : FloorStoreError?) {
        self.floors = floors
        for floor in floors {
            seg.insertSegment(withTitle: floor.title, at: seg.numberOfSegments, animated: false)
            APIReloadManager.fetchImg(floor.img, id: floor.objectID, service : floorService, completedAction: completed)
        }
    }
    
    func completed(_ callBack :CallbackProtocol) {
        //print("fetch img")
        change(seg)
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        if let nav = self.navigationController as? HuntlyNavigationController {
            self.navigationItem.leftBarButtonItem = nav.huntlyLeftButton
        }
        
        seg = UISegmentedControl()
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.insertSegment(withTitle: "Venue map", at: 0, animated: false)
        
        navigationController?.navigationBar.isTranslucent = false
        
        setupSegments()
        
        seg.addTarget(self, action: #selector(self.change(_:)), for: .valueChanged)
        
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
        
        let horizontalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[seg]-10-|", options: layout, metrics: nil, views: viewDictionary)
        
        let horizontalContraint1:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[accessView]-0-|", options: layout, metrics: nil, views: viewDictionary)
        
        let verticalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[seg(30)]-10-[accessView]-0-|", options: layout, metrics: nil, views: viewDictionary)
        
        
        view.addConstraints(horizontalContraint0)
        view.addConstraints(horizontalContraint1)
        view.addConstraints(verticalContraint0)
        
        
        seg.selectedSegmentIndex = 0
        
        view.layoutIfNeeded()
        
        
        segZero()
        
        
        
        
        
        
        
    }
    
    func change(_ sender : UISegmentedControl) {
        
        
        if(sender.selectedSegmentIndex == 0) {
            segZero()
        }
        
        if(sender.selectedSegmentIndex > 0) {
            
            let currentFloor = floors[sender.selectedSegmentIndex - 1]
            
            currentView?.removeFromSuperview()
            
            /*
            let v = UIImageView(frame: CGRectMake(0, 0, accessView.frame.width, accessView.frame.height))
            v.image = UIImage(data: currentFloor.imgData)
            currentView = v
            accessView.addSubview(currentView!)
            */
            
            
            let imageView = UIImageView(image: UIImage(data: currentFloor.imgData as Data))
            
            let scrollView = UIScrollView(frame: view.bounds)
            scrollView.backgroundColor = UIColor.black
            scrollView.contentSize = imageView.bounds.size
            scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
            
            scrollView.addSubview(imageView)
            currentView = scrollView
            accessView.addSubview(currentView!)
            
        }
    }
    
    
    func segZero() {
        currentView?.removeFromSuperview()
        let controller = MapController()
        controller.view.frame = CGRect(x: 0, y: 0, width: accessView.frame.width, height: accessView.frame.height)
        currentView = controller.view
        controller.reset()
        accessView.addSubview(currentView!)
    }
}
