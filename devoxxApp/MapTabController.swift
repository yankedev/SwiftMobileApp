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
    
    override public func viewDidLoad() {
        
        
        seg = UISegmentedControl(frame: CGRectMake(40,80,300,25))

        seg.insertSegmentWithTitle("Venue map", atIndex: 0, animated: false)
        seg.insertSegmentWithTitle("First floor", atIndex: 1, animated: false)
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
        
        
        self.title = "Palais des Congres, porte Maillot"
        
        
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
        
        if(sender.selectedSegmentIndex == 1) {

            let decodedData = APIManager.getDataFromName("DevoxxFRExhibitionPhone.jpg")
            
                      currentView?.removeFromSuperview()
            let v = UIImageView(frame: CGRectMake(0, 0, accessView.frame.width, accessView.frame.height))
            v.image = UIImage(data: decodedData)
            currentView = v
            accessView.addSubview(currentView!)
        }
        /*
        if(sender.selectedSegmentIndex == 2) {
            currentView?.removeFromSuperview()
            let v = UIImageView(frame: CGRectMake(0, 0, accessView.frame.width, accessView.frame.height))
            v.image = UIImage(named: "devoxx2015_floor_2.jpg")
            currentView = v
            accessView.addSubview(currentView!)
            
            
            let imgData = UIImageJPEGRepresentation(v.image!, 1.0)
            let str = imgData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
            
            
        }
        */
        

        
    }
    
    func back() {
        print("BACK")
        self.parentViewController!.parentViewController?.view!.removeFromSuperview()
        self.parentViewController?.parentViewController?.removeFromParentViewController()
    }
    
}
