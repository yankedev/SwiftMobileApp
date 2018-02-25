//
//  ViewController.swift
//  MDRotatingPieChart
//
//  Created by Maxime DAVID on 2015-04-03.
//  Copyright (c) 2015 Maxime DAVID. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, SelectionWheelDatasource, SelectionWheelDelegate {
    
    var slicesData:NSArray!
    let wheelView = SelectionWheel()
    
    
    let color = UIColor(red: 255/255, green: 152/255, blue: 0/255, alpha: 1)
    let customTabController = UITabBarController()
    var currentSelectedIndex = 0
    var imgView:UIImageView!
    var numberView:HomeNumberView!
    var goView:HomeGoButtonView!
    var globeView:UIView!
    var eventLocation:UILabel!
    var rotating = false
    
    fileprivate struct AlertString {
        struct NoDataError {
            static let title = NSLocalizedString("No Data", comment: "")
            static let content = NSLocalizedString("Please select another event", comment: "")
            static let okButton = NSLocalizedString("Sure !", comment: "")
        }
    }
    
    fileprivate struct TabNameString {
        static let schedule = NSLocalizedString("Schedule", comment: "")
        static let tracks = NSLocalizedString("Tracks", comment: "")
        static let speakers = NSLocalizedString("Speakers", comment: "")
        static let map = NSLocalizedString("Map", comment: "")
        static let settings = NSLocalizedString("Settings", comment: "")
    }
    
    
    
    
    
    
    func run_on_background_thread(_ code: @escaping () -> Void) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: code)
    }
    
    func run_on_main_thread(_ code: @escaping () -> Void) {
        DispatchQueue.main.async(execute: code)
    }
    
    
    
    
    func rotateOnce() {
        
        if self.globeView == nil {
            return
        }
        
        UIView.animate(withDuration: 0.5,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.globeView.transform = self.globeView.transform.rotated(by: 3.1415926)
            },
            completion: {finished in self.rotateAgain()})
    }
    
    func rotateAgain() {
        UIView.animate(withDuration: 0.5,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.globeView.transform = self.globeView.transform.rotated(by: 3.1415926)
            },
            completion: {finished in if self.rotating { self.rotateOnce() }})
    }
    
    
    
    
    func loadIsFinihsed() {
        
        
        
        
        let scheduleController = ScheduleController<SchedulerTableViewController<Talk>>()
        
        
        let trackController = TrackController<TrackTableViewController<Talk>>()
        
        let speakerController = SpeakerTableController()
        let mapController = MapTabController()
        let settingsController = SettingsController()
        
        let scheduleTabImage = UIImage(named: "tabIconSchedule.png")
        let trackTabImage = UIImage(named: "tabIconTracks.png")
        let speakerTabImage = UIImage(named: "tabIconSpeaker.png")
        let mapTabImage = UIImage(named: "tabIconMap.png")
        let settingsTabImage = UIImage(named: "tabIconSettings.png")
        
        scheduleController.tabBarItem = UITabBarItem(title: TabNameString.schedule, image: scheduleTabImage, tag:0)
        trackController.tabBarItem = UITabBarItem(title: TabNameString.tracks, image: trackTabImage, tag:1)
        speakerController.tabBarItem = UITabBarItem(title: TabNameString.speakers, image: speakerTabImage, tag:2)
        mapController.tabBarItem = UITabBarItem(title: TabNameString.map, image: mapTabImage, tag:3)
        settingsController.tabBarItem = UITabBarItem(title: TabNameString.settings, image: settingsTabImage, tag:4)
        
        let speakerNavigationController = HuntlyNavigationController(rootViewController: speakerController)
        
        let settingsNavigationController = HuntlyNavigationController(rootViewController: settingsController)
        
        let mapNavigationController = HuntlyNavigationController(rootViewController: mapController)
        
        self.customTabController.viewControllers = [scheduleController, trackController, speakerNavigationController, mapNavigationController, settingsNavigationController]
        self.customTabController.tabBar.isTranslucent = false
        self.customTabController.view.backgroundColor = UIColor.white
        
        
        self.rotating = false
        
        self.customTabController.selectedIndex = 0
        
        //self.navigationController?.pushViewController(self.customTabController, animated: true)
        
        
        
        self.addChildViewController(self.customTabController)
        self.view.addSubview(self.customTabController.view)
        
        feedEventId()
        
    }
    func fail() {
    }
    
    func feedEventId() {
        HuntlyManagerService.sharedInstance.feedEventId(prepareHuntly, callbackFailure: fail)
    }
    
    func prepareHuntly() {
        HuntlyManagerService.sharedInstance.storeToken("firstAppRun", handlerSuccess : hunltyManager, handlerFailure: fail)
    }
    
    func hunltyManager() {

        if let viewController = UIStoryboard(name: "Huntly", bundle: nil).instantiateViewController(withIdentifier: "HuntlyPopup") as? HuntlyPopup {
 
            self.customTabController.present(viewController, animated: true, completion: {
            
                viewController.titleBonus.text = "Welcome bonus"
                viewController.pointLbl.text = "Points"
                viewController.pointValueLbl.text = "+\(HuntlyManagerService.sharedInstance.FIRST_APP_RUN_QUEST_POINTS)"
                
            })

            
        }
        
    }
       
    func prepareNext() {
        if let currentData = slicesData[currentSelectedIndex] as? EventProtocol {
            
            
            let defaults = UserDefaults.standard
            defaults.set(currentData.identifier(), forKey: "currentEvent")
            CfpService.sharedInstance.currentCfp = nil
            
            
            
            //defaults.setObject(currentData.identifier(), forKey: "currentEvent")
            rotating = true
            rotateOnce()
            self.showStaticView(true)
            run_on_background_thread {
                self.fetchEvent()
                self.run_on_main_thread{
                    self.rotateOnce()
                }
            }
        }
    }
    
    
    func showStaticView(_ show : Bool) {
        self.wheelView.isUserInteractionEnabled = !show
        self.goView.isHidden = show
    }
    
    func remove() {
        customTabController.view.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        
        
        self.view.addSubview(imgView)
        
        let headerView = HomeHeaderView()
        
        goView = HomeGoButtonView()
        numberView = HomeNumberView()
        
        
        eventLocation = headerView.eventLocation
        
        
        
        view.addSubview(headerView)
        view.addSubview(wheelView)
        view.addSubview(goView)
        view.addSubview(numberView)
        
        
        let viewsDictionary = ["headerView":headerView, "wheelView":wheelView, "goView":goView, "numberView":numberView]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint0:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headerView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        let horizontalContraint1:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[wheelView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        let horizontalContraint2:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[goView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        let horizontalContraint3:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[numberView]-0-|", options: layout, metrics: nil, views: viewsDictionary)
        
        
        let v1 = NSLayoutConstraint(item: headerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 0.15, constant: 0)
        let v2 = NSLayoutConstraint(item: wheelView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 0.6, constant: 0)
        let v3 = NSLayoutConstraint(item: goView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 0.1, constant: 0)
        let v4 = NSLayoutConstraint(item: numberView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 0.15, constant: 0)
        
        
        let verticalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[headerView]-0-[wheelView]-0-[goView]-0-[numberView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        
        self.view.addConstraints(horizontalContraint0)
        self.view.addConstraints(horizontalContraint1)
        self.view.addConstraints(horizontalContraint2)
        self.view.addConstraints(horizontalContraint3)
        
        self.view.addConstraints(verticalContraint)
        
        
        self.view.addConstraint(v1)
        self.view.addConstraint(v2)
        self.view.addConstraint(v3)
        self.view.addConstraint(v4)
        
        
        numberView.applyConstraint()
        
        
        
        
        
        view.layoutIfNeeded()
        wheelView.layoutIfNeeded()
        
        
        
        
        
        
        
        
        
        
        
        goView.goButton.addTarget(self, action: #selector(self.prepareNext), for: .touchUpInside)
        
        
        APIManager.firstFeed(loadWheel, service: CfpService.sharedInstance)
        
    }
    
    func loadWheel(_ msg : CallbackProtocol) {
        CfpService.sharedInstance.fetchCfps(callBack)
    }
    
    func callBack(_ cfps :[Cfp], error : CfpStoreError?) {
        slicesData = cfps as NSArray
        
        wheelView.datasource = self
        wheelView.delegate = self
        
        wheelView.setup()
        wheelView.click(0)
        globeView = wheelView.globe
        
        //shouldByPass()
    }
    
    func shouldByPass() {
        
        let selectedEvent = APIManager.getSelectedEvent()
        
        if selectedEvent == "" {
            wheelView.click(0)
        }
        else {
            var idx = 0
            for singleData in slicesData {
                if let singleDataEvent = singleData as? EventProtocol {
                    if singleDataEvent.identifier() == selectedEvent {
                        break
                    }
                    else {
                        idx += 1
                    }
                }
            }
       
            
            wheelView.click(0)
            showStaticView(true)
            prepareNext()
        }
        
        
        
        
        
        
        /*
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let currentEventIndex = defaults.objectForKey("currentEvent") as? String {
        //  print("READDING 2 \(currentEventIndex)")
        if currentEventIndex == "" {
        return
        }
        else {
        //   print("coucou ->\(currentEventIndex)")
        prepareNext()
        }
        }
        else {
        // print("SETTINH 2 ")
        defaults.setObject("", forKey: "currentEvent")
        return
        }
        */
    }
    
    
    //Delegate
    //some sample messages when actions are triggered (open/close slices)
    func didOpenSliceAtIndex(_ index: Int) {
        
    }
    
    func didCloseSliceAtIndex(_ index: Int) {
        
    }
    
    func willOpenSliceAtIndex(_ index: Int) {
        
        
    }
    
    func willCloseSliceAtIndex(_ index: Int) {
        
    }
    
    //Datasource
    func colorForSliceAtIndex(_ index:Int) -> UIColor {
        return color
    }
    
    func valueForSliceAtIndex(_ index:Int) -> CGFloat {
        return CGFloat(100/slicesData.count)
    }
    
    func labelForSliceAtIndex(_ index:Int) -> String {
        if let currentData = slicesData[index] as? EventProtocol {
            return currentData.title()
        }
        return ""
    }
    
    func imageForSliceAtIndex(_ index:Int) -> UIImage {
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
    
    func updateIndex(_ index:Int) {
        currentSelectedIndex = index
        if let currentData = slicesData[index] as? EventProtocol {
            let img = UIImage(data: currentData.backgroundImage() as Data)
            let tmpImageView = UIImageView(image: img)
            imgView.image = img
            imgView.frame = tmpImageView.frame
            eventLocation.text = currentData.title()
            
            numberView.number1.text = currentData.daysLeft()
            numberView.number2.text = currentData.sessionsCount()
            numberView.number3.text = currentData.capacityCount()
            
            
            
        }
        
    }
    
    
    
    
    func failure(_ msg : String) {
        //print("FAILURE")
        self.showStaticView(false)
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "currentEvent")
        CfpService.sharedInstance.cfp = nil
        self.rotating = false
        let alert = UIAlertController(title: AlertString.NoDataError.title, message: AlertString.NoDataError.content, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: AlertString.NoDataError.okButton, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func fetchEvent() {
        print(CfpService.sharedInstance.getEntryPoint())
        
        APIDataManager.loadDataFromURL(CfpService.sharedInstance.getEntryPoint(), service: DayService.sharedInstance, helper : DayHelper(), loadFromFile : false, onSuccess: self.fetchSpeakers, onError: self.failure)
    }
    
    func fetchSpeakers(_ msg : CallbackProtocol) {
        APIDataManager.loadDataFromURL(SpeakerService.sharedInstance.getSpeakerUrl(), service: SpeakerService.sharedInstance, helper : SpeakerHelper(), loadFromFile : false, onSuccess: self.setupEvent, onError: self.failure)
    }
    

    
    func setupEvent(_ msg : CallbackProtocol) {
       // print("========setupEvent")
        
        
        if CfpService.sharedInstance.getNbDays() > 0 {
            APIDataManager.loadDataFromURL(CfpService.sharedInstance.getFileTalkUrl(), service: SlotService.sharedInstance, helper: SlotHelper(), loadFromFile : false, onSuccess: self.fetchTracks, onError: self.failure)
        }
        else {
            run_on_main_thread({
                self.failure("")
            })
        }
        
        
        
    }
    
    func fetchTracks(_ msg : CallbackProtocol) {
        //print("========fetchTracks")
        APIDataManager.loadDataFromURL(AttributeService.sharedInstance.getTracksUrl(), service: TrackService.sharedInstance, helper : TrackHelper(), loadFromFile: false, onSuccess: self.fetchTalkType, onError: failure)
    }
    
    
    
    func fetchTalkType(_ msg : CallbackProtocol) {
        //print("========fetchTalkType")
        APIDataManager.loadDataFromURL(AttributeService.sharedInstance.getTalkTypeUrl(), service: TalkTypeService.sharedInstance, helper : TalkTypeHelper(), loadFromFile: false, onSuccess: self.finishFetching, onError: failure)
    }
    
    func finishFetching(_ msg : CallbackProtocol) {
        self.rotating = false
        self.showStaticView(false)
        self.loadIsFinihsed()
    }
    

    
}


