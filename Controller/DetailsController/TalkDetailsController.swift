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
    
    @IBOutlet var talkList: UITableView!
    @IBOutlet var scroll: UITextView!
    @IBOutlet var starBtn: UIButton!
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var tweetBtn: UIButton!
    @IBOutlet var tweet: UIView!
    @IBOutlet var star: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var talkTitle: UILabel!
    var txtField : UITextField!
    let details = GobalDetailView()
    @IBOutlet var header: UIImageView!
    

    @IBOutlet var talkTrack: UILabel!
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        talkTitle.text = detailObject.getTitle()
        talkTrack.text = detailObject.getSubTitle()
        scroll.text = detailObject.getSummary()
        
        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        tweet.backgroundColor = ColorManager.topNavigationBarColor
        tweet.layer.cornerRadius = tweet.frame.size.width / 2
        
        star.backgroundColor = ColorManager.topNavigationBarColor
        star.layer.cornerRadius = star.frame.size.width / 2
        
        let image0 = UIImage(named: "ic_twitter")?.imageWithRenderingMode(.AlwaysTemplate)
        tweetBtn.setImage(image0, forState: .Normal)
        tweetBtn.tintColor = UIColor.whiteColor()
        
        
        let image1 = UIImage(named: "ic_star")?.imageWithRenderingMode(.AlwaysTemplate)
        starBtn.setImage(image1, forState: .Normal)
        starBtn.tintColor = UIColor.whiteColor()
        
        let image2 = UIImage(named: "ic_back")?.imageWithRenderingMode(.AlwaysTemplate)
        backBtn.setImage(image2, forState: .Normal)
        backBtn.tintColor = UIColor.whiteColor()
        
        
        backBtn.addTarget(self, action: #selector(self.back), forControlEvents: .TouchUpInside)
        
     
        details.left.simpleDetailView1.textView.firstInfo.text = "Room"
        details.left.simpleDetailView1.textView.secondInfo.text = detailObject.getDetailInfoWithIndex(0)
        
        details.left.simpleDetailView2.textView.firstInfo.text = "Format"
        details.left.simpleDetailView2.textView.secondInfo.text = detailObject.getDetailInfoWithIndex(1)
        
        
        
        details.left.simpleDetailView3.textView.firstInfo.text = "Date and time"
        details.left.simpleDetailView3.textView.secondInfo.text = detailObject.getDetailInfoWithIndex(2)
        
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
        self.details.right.reloadData()
    }
    
  
  

    
    
    
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        parentViewController?.navigationController?.setNavigationBarHidden(true, animated: true)

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            SpeakerService.sharedInstance.fetchSpeakers(self.detailObject.getRelatedIds(), completionHandler:self.callBack)
        })
        
        
        //header.imageView.hidden = true
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
    
   
    
    
    public func twitter() {
        
        /*let originalString = detailObject.getTwitter()
 
        
        let escapedString = originalString?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
 
 */
    }
    
    
    
   
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .None
        }
        
        
        
        
        
        
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
        qrCodeScannerController.completionOnceScanned = rate
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
    
    
    
    public func rate() {
        
        if let rateObj = detailObject as? RatableProtocol {
            
            let rateController = RateTableViewController()
            rateController.rateObject = rateObj
            let rateNavigationController = UINavigationController(rootViewController: rateController)
            presentViewController(rateNavigationController, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    public func tryToRate() {
        
        if APIManager.qrCodeAlreadyScanned() {
            rate()
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
    
 
    
}