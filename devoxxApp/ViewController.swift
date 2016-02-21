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
    var ctrl:ContainerController!
    let color = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
    let tabController = UITabBarController()
    
    var imgView:UIImageView!

    func generateScheduleTableViewController() -> ScrollableDateProtocol {
        return SchedulerTableViewController()
    }
    
    func generate() -> ScrollableItemProtocol {
        return MapController()
    }

    
    
    func prepareNext() {
        
        
        //selectedEvent
        APIManager.setEvent(slicesData.objectAtIndex(ctrl.pieChart.currentSelected) as! Cfp)
        
        
        
        
        
        let scheduleController = ScheduleController<SchedulerTableViewController>(generator:generateScheduleTableViewController)
        let speakerController = SpeakerTableController()
        let mapController = MapTabController()
        
        let scheduleTabImage = UIImage(named: "tabIconSchedule.png")
        let speakerTabImage = UIImage(named: "tabIconSpeaker.png")
        let mapTabImage = UIImage(named: "tabIconMap.png")
        
        scheduleController.tabBarItem = UITabBarItem(title: "Schedule", image: scheduleTabImage, tag:0)
        speakerController.tabBarItem = UITabBarItem(title: "Speakers", image: speakerTabImage, tag:1)
        mapController.tabBarItem = UITabBarItem(title: "Map", image: mapTabImage, tag:2)
        
        //let scheduleNavigationController = UINavigationController(rootViewController: scheduleController)
        let speakerNavigationController = UINavigationController(rootViewController: speakerController)
        
        
        
        
        let scroll = GenericPageScrollController<MapController>(generator:generate)
        
       let mapNavigationController = UINavigationController(rootViewController: mapController)
        
        
        tabController.viewControllers = [scheduleController, speakerNavigationController, mapNavigationController]
        tabController.tabBar.translucent = false
        tabController.view.backgroundColor = UIColor.whiteColor()
        //TODO BACK BUTTON
        //self.navigationController?.navigationBarHidden = false
        
        addChildViewController(tabController)
        view.addSubview(tabController.view)
        //self.navigationController?.pushViewController(tabController, animated: true)

    }
    
    func remove() {
        tabController.view.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.redColor()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let wheelView = UIView()
        wheelView.backgroundColor = UIColor.greenColor()
        wheelView.translatesAutoresizingMaskIntoConstraints = false
        let goView = UIView()
        goView.backgroundColor = UIColor.blueColor()
        goView.translatesAutoresizingMaskIntoConstraints = false
        let numberView = UIView()
        numberView.backgroundColor = UIColor.yellowColor()
        numberView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        view.addSubview(wheelView)
        view.addSubview(goView)
        view.addSubview(numberView)
        
        
        let viewsDictionary = ["headerView":headerView, "wheelView":wheelView, "goView":goView, "numberView":numberView]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[headerView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        let horizontalContraint1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[wheelView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        let horizontalContraint2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[goView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        let horizontalContraint3:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[numberView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        
        
        let height = view.frame.size.height
        
        let verticalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[headerView(\(0.15*height))]-0-[wheelView(\(0.6*height))]-0-[goView(\(0.1*height))]-0-[numberView(\(0.15*height))]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        
        self.view.addConstraints(horizontalContraint0)
        self.view.addConstraints(horizontalContraint1)
        self.view.addConstraints(horizontalContraint2)
        self.view.addConstraints(horizontalContraint3)
        
        self.view.addConstraints(verticalContraint)
        
        
        
        /*
        imgView = UIImageView(image: UIImage(named: "DevoxxMoroccoHomePage.jpg")!)
        self.view.addSubview(imgView)
        
        
        ctrl = ContainerController()
        
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


