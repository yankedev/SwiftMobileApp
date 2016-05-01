//
//  TalkDetailsController.swift
//  devoxxApp
//
//  Created by maxday on 13.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

public class TalkDetailsController : UIViewController, UITableViewDataSource, UITableViewDelegate, HotReloadProtocol, FavoritableProtocol {
    
    @IBOutlet var backBtn: UIButton!
    var detailObject : DetailableProtocol!
    
    @IBOutlet var roomLabel: UILabel!
    
    @IBOutlet var roomValueLabel: UILabel!

 
    @IBOutlet var talkTypeLabel: UILabel!
    @IBOutlet var talkTypeValueLabel: UILabel!
    
    @IBOutlet var timeValueLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var talkList: UITableView!
    @IBOutlet var scroll: UITextView!
    @IBOutlet var starBtn: UIButton!
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var tweetBtn: UIButton!
    @IBOutlet var tweet: UIView!
    @IBOutlet var rateBtn: UIButton!
    @IBOutlet var rate: UIView!
    @IBOutlet var star: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var talkTitle: UILabel!
    var txtField : UITextField!
    let details = GobalDetailView()
    @IBOutlet var header: UIImageView!
    

    @IBOutlet var talkTrack: UILabel!
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let rateDetails = detailObject as? RatableProtocol {
            if !rateDetails.isEnabled() {
                //actionButtonView2.hidden = true
            }
        }
        
        
        talkTitle.text = detailObject.getTitle()
        talkTrack.text = detailObject.getSubTitle()
        scroll.text = detailObject.getSummary()
        
        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        tweet.backgroundColor = ColorManager.topNavigationBarColor
        tweet.layer.cornerRadius = tweet.frame.size.width / 2
        
        star.backgroundColor = ColorManager.topNavigationBarColor
        star.layer.cornerRadius = star.frame.size.width / 2
        
        rate.backgroundColor = ColorManager.topNavigationBarColor
        rate.layer.cornerRadius = rate.frame.size.width / 2
        
        let image0 = UIImage(named: "ic_twitter")?.imageWithRenderingMode(.AlwaysTemplate)
        tweetBtn.setImage(image0, forState: .Normal)
        tweetBtn.tintColor = UIColor.whiteColor()
        
        
        let image1 = UIImage(named: "ic_star")?.imageWithRenderingMode(.AlwaysTemplate)
        starBtn.setImage(image1, forState: .Normal)
        starBtn.tintColor = UIColor.whiteColor()
        
        let image2 = UIImage(named: "ic_back")?.imageWithRenderingMode(.AlwaysTemplate)
        backBtn.setImage(image2, forState: .Normal)
        backBtn.tintColor = UIColor.whiteColor()
        
        let image3 = UIImage(named: CfpService.sharedInstance.getVotingImage())
        rateBtn.setImage(image3, forState: .Normal)




        
        
        backBtn.addTarget(self, action: #selector(self.back), forControlEvents: .TouchUpInside)
        
     
        roomLabel.text = "Room"
        roomValueLabel.text = detailObject.getDetailInfoWithIndex(0)
        
        talkTypeLabel.text = "Format"
        talkTypeValueLabel.text = detailObject.getDetailInfoWithIndex(1)
        
        
        
        timeLabel.text = "Date and time"
        timeValueLabel.text = detailObject.getDetailInfoWithIndex(2)
        
        details.right.dataSource = self
        details.right.delegate = self
        
        
      
        
        
        
        talkList.delegate = self
        talkList.dataSource = self
        
        
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
  
    
    func callBack(speakers : [DataHelperProtocol], error : SpeakerStoreError?) {
        detailObject.setRelated(speakers)
        talkList.reloadData()
    }
    
  
  

    
    
    
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        parentViewController?.navigationController?.setNavigationBarHidden(true, animated: true)

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            SpeakerService.sharedInstance.fetchSpeakers(self.detailObject.getRelatedIds(), completionHandler:self.callBack)
        })
        
        

        //header.imageView.hidden = true
        
        //sync with watch
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name:"UpdateFavorite", object: nil)
    }
    
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UpdateFavorite", object: nil)
    }
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if let speaker = detailObject.getRelatedDetailWithIndex(indexPath.row) {
            
            
            let details = SpeakerDetailsController()
            details.delegate = self
            
            details.detailObject = speaker
     
            
           
            
            details.configure()
            details.setColor(speaker.isFavorited())
            
            self.navigationController?.pushViewController(details, animated: true)
        }
        */
        
        
        
    }
    
   

    
    
    
    
   
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL_10")
        
        cell?.textLabel?.font = UIFont(name: "Roboto", size: 15)
        cell?.textLabel?.text = detailObject.getRelatedDetailWithIndex(indexPath.row)?.getTitle()
        
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
        
    }
    
    
    
    
    
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchUpdate()
    }
    
    
    func checkCamera() {
        AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
        case .Authorized:
            scan()
            break // Do you stuffer here i.e. allowScanning()
        case .Denied: enterManually()
        default: break;
        }
    }
    
    
    public func fetchUpdate() {
        
        APIReloadManager.fetchUpdate(fetchUrl(), service: SlotService.sharedInstance, completedAction: fetchCompleted)
        
    }
    
    public func fetchCompleted(msg : CallbackProtocol) -> Void {
        
    }
    
   
    public func favorite(id : NSManagedObjectID) -> Bool {
        return TalkService.sharedInstance.invertFavorite(id)
    }
    
    public func scan() {
        let qrCodeScannerController = QRCodeScannerController()
        qrCodeScannerController.completionOnceScanned = goToRate
        let qrCodeNavigationController = UINavigationController(rootViewController: qrCodeScannerController)
        presentViewController(qrCodeNavigationController, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!) {
        
        if let tField = textField {
            txtField = tField
        }
    }
    
    func validateQrCode() {
        APIManager.setQrCode(txtField.text!)
        tryToRate()
    }
    
    public func enterManually() {
        
        let alert = UIAlertController(title: "QRCode", message: "Enter the code :", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.validateQrCode()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    public func hasBeenGranted(isGranted : Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.checkCamera()
        })
    }
    
    public func triggerRequestAccess() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: hasBeenGranted)
    }
    
    
    
    public func goToRate() {
        
        if let rateObj = detailObject as? RatableProtocol {
            
            let rateController = RateTableViewController()
            rateController.rateObject = rateObj
            let rateNavigationController = UINavigationController(rootViewController: rateController)
            presentViewController(rateNavigationController, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    public  func tryToRate() {
        
        if APIManager.qrCodeAlreadyScanned() {
            goToRate()
        }
        else {
            let alert = UIAlertController(title: "QRCode", message: "Please scan your badge QRCode or enter the code on your badge to authenticate yourself for presentation voting", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Scan", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.triggerRequestAccess()}))
            alert.addAction(UIAlertAction(title: "Enter manually", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.enterManually()}))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailObject.getRelatedDetailsCount()
    }
    
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    public func fetchUrl() -> String? {
        return ""
        
    }
    
 

    func handleNotification(notification: NSNotification){
        //invertColor()
    }
    


    
}