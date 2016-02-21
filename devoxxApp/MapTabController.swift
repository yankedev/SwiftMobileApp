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
    
    var floors:[Floor]!
    
    func setupSegments() {
        floors = APIManager.currentEvent.getImages()
        for floor in floors {
            seg.insertSegmentWithTitle(floor.title, atIndex: seg.numberOfSegments, animated: false)
        }
    }
    
    override public func viewDidLoad() {
        
        
        
        seg = UISegmentedControl(frame: CGRectMake(40,80,300,25))

        seg.insertSegmentWithTitle("Venue map", atIndex: 0, animated: false)
        
        setupSegments()
        
        seg.addTarget(self, action: Selector("change:"), forControlEvents: .ValueChanged)
        
        seg.tintColor = ColorManager.topNavigationBarColor
        seg.selectedSegmentIndex = 0
        
        
        accessView = UIView(frame: CGRectMake(0,120,380,600))
        
        currentView?.removeFromSuperview()
        let controller = MapController()
        controller.view.frame = CGRectMake(0, 0, accessView.frame.width, accessView.frame.height)
        currentView = controller.view
        controller.reset()
        accessView.addSubview(currentView!)
        
        self.view.addSubview(seg)
        self.view.addSubview(accessView)
        
        
        self.navigationItem.title = APIManager.currentEvent.address
        
        
        let backLeftButton = UIBarButtonItem(barButtonSystemItem: .Reply, target: self, action: Selector("back"))
        
        self.navigationItem.leftBarButtonItem = backLeftButton
        
        
        
    }
    
    func change(sender : UISegmentedControl) {
        print("changed")
        
        if(sender.selectedSegmentIndex == 0) {
            currentView?.removeFromSuperview()
            let controller = MapController()
            controller.view.frame = CGRectMake(0, 0, accessView.frame.width, accessView.frame.height)
            currentView = controller.view
            controller.reset()
            accessView.addSubview(currentView!)
        }
        
        if(sender.selectedSegmentIndex > 0) {

            let imageName = floors[sender.selectedSegmentIndex - 1].img
            let decodedData = APIManager.getDataFromName(imageName)
            
            currentView?.removeFromSuperview()
            let v = UIImageView(frame: CGRectMake(0, 0, accessView.frame.width, accessView.frame.height))
            v.image = UIImage(data: decodedData)
            currentView = v
            accessView.addSubview(currentView!)
        }
    }
    
    func back() {
        print("BACK")
        self.parentViewController!.parentViewController?.view!.removeFromSuperview()
        self.parentViewController?.parentViewController?.removeFromParentViewController()
    }
    
}
