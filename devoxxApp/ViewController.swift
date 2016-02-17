//
//  ViewController.swift
//  MDRotatingPieChart
//
//  Created by Maxime DAVID on 2015-04-03.
//  Copyright (c) 2015 Maxime DAVID. All rights reserved.
//

import UIKit


class ViewController: UIViewController, MDRotatingPieChartDelegate, MDRotatingPieChartDataSource {
    
    var slicesData:NSArray!
    let color = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
    
    
    var imgView:UIImageView!

    func generateScheduleTableViewController() -> ScrollableDateProtocol {
        return SchedulerTableViewController()
    }

    
    
    func prepareNext() {
        let scheduleController = ScheduleController<SchedulerTableViewController>(generator:generateScheduleTableViewController)
        let speakerController = SpeakerTableController()
        let mapController = MapController()
        
        let scheduleTabImage = UIImage(named: "tabIconSchedule.png")
        let speakerTabImage = UIImage(named: "tabIconSpeaker.png")
        let mapTabImage = UIImage(named: "tabIconMap.png")
        
        scheduleController.tabBarItem = UITabBarItem(title: "Schedule", image: scheduleTabImage, tag:0)
        speakerController.tabBarItem = UITabBarItem(title: "Speakers", image: speakerTabImage, tag:1)
        mapController.tabBarItem = UITabBarItem(title: "Map", image: mapTabImage, tag:2)
        
        //let scheduleNavigationController = UINavigationController(rootViewController: scheduleController)
        let speakerNavigationController = UINavigationController(rootViewController: speakerController)
        let mapNavigationController = UINavigationController(rootViewController: mapController)
        
        let tabController = UITabBarController()
        tabController.viewControllers = [scheduleController, speakerNavigationController, mapNavigationController]
        tabController.tabBar.translucent = false
        tabController.view.backgroundColor = UIColor.whiteColor()
        //TODO BACK BUTTON
        //self.navigationController?.navigationBarHidden = false
        
        addChildViewController(tabController)
        view.addSubview(tabController.view)
        //self.navigationController?.pushViewController(tabController, animated: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        imgView = UIImageView(image: UIImage(named: "DevoxxMoroccoHomePage.jpg")!)
        self.view.addSubview(imgView)
        
        
        let ctrl = ContainerController()
        
        ctrl.initi()
        

        ctrl.goButton.addTarget(self, action: Selector("prepareNext"), forControlEvents: .TouchUpInside)
        
        slicesData = APIManager.getAllEvents()
        
        
        ctrl.pieChart.delegate = self
        ctrl.pieChart.datasource = self
    
        view.addSubview(ctrl.view)
        
        
        
        ctrl.pieChart.build()
        /* 
        Here you can dig into some properties
        -------------------------------------
        
        var properties = Properties()

        properties.smallRadius = 50
        properties.bigRadius = 120
        properties.expand = 25
    
        
        properties.displayValueTypeInSlices = .Percent
        properties.displayValueTypeCenter = .Label
        
        properties.fontTextInSlices = UIFont(name: "Arial", size: 12)!
        properties.fontTextCenter = UIFont(name: "Arial", size: 10)!

        properties.enableAnimation = true
        properties.animationDuration = 0.5
        
        
        var nf = NSNumberFormatter()
        nf.groupingSize = 3
        nf.maximumSignificantDigits = 2
        nf.minimumSignificantDigits = 2
        
        properties.nf = nf
        
        pieChart.properties = properties
        */
        

    }
    
    //Delegate
    //some sample messages when actions are triggered (open/close slices)
    func didOpenSliceAtIndex(index: Int) {
        print("Open slice at \(index)")
    }
    
    func didCloseSliceAtIndex(index: Int) {
        print("Close slice at \(index)")
    }
    
    func willOpenSliceAtIndex(index: Int) {
        if let currentData = slicesData[index] as? EventProtocol {
            imgView.image = UIImage(data: currentData.backgroundImage())
        }
    }
    
    func willCloseSliceAtIndex(index: Int) {
        print("Will close slice at \(index)")
    }
    
    //Datasource
    func colorForSliceAtIndex(index:Int) -> UIColor {
        return color
    }
    
    func valueForSliceAtIndex(index:Int) -> CGFloat {
        return CGFloat(100/slicesData.count)
    }
    
    func numbersForSliceAtIndex(index:Int) -> Array<Int> {
        if let currentData = slicesData[index] as? EventProtocol {
            return currentData.numbers()
        }
        return [0,0,0]
    }
    
    func labelForSliceAtIndex(index:Int) -> String {
        if let currentData = slicesData[index] as? EventProtocol {
            return currentData.title()
        }
        return ""
    }
    
    func imageForSliceAtIndex(index:Int) -> UIImage {
        if let currentData = slicesData[index] as? EventProtocol {
            return UIImage(named: currentData.splashImageName())!
        }
        //TODO
        return UIImage(named: "sample.png")!
    }
    
    func numberOfSlices() -> Int {
        return slicesData.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


