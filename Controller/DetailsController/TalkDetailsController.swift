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

open class TalkDetailsController : AbstractDetailsController, UITableViewDataSource, UITableViewDelegate, HotReloadProtocol, FavoritableProtocol {
    
    
    var txtField : UITextField!
    let details = GobalDetailView()
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let rateDetails = detailObject as? RatableProtocol {
            if !rateDetails.isEnabled() {
                actionButtonView2.isHidden = true
            }
        }
        
        details.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(details)
        
        let views = ["header": header, "scroll" : scroll, "details" : details] as [String : Any]
        
        let constH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[header]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[scroll]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        let constH5 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[details]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        let constV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[header(150)]-[details(150)]-[scroll]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constH5)
        
        view.addConstraints(constV)
        
        
        header.talkTitle.text = detailObject.getTitleD()
        header.talkTrack.text = detailObject.getSubTitle()
        scroll.text = detailObject.getSummary()
        
        
        
        details.layoutIfNeeded()
        
        details.left.simpleDetailView1.textView.firstInfo.text = "Room"
        details.left.simpleDetailView1.textView.secondInfo.text = detailObject.getDetailInfoWithIndex(0)
        
        details.left.simpleDetailView2.textView.firstInfo.text = "Format"
        details.left.simpleDetailView2.textView.secondInfo.text = detailObject.getDetailInfoWithIndex(1)
        
        
        
        details.left.simpleDetailView3.textView.firstInfo.text = "Date and time"
        details.left.simpleDetailView3.textView.secondInfo.text = detailObject.getDetailInfoWithIndex(2)
        
        
        
        
        details.right.dataSource = self
        details.right.delegate = self
        
        
        
        
        configure()
        
        
        
        
        view.layoutIfNeeded()
        
        
        
        
        
    }
    
  
    
    func callBack(_ speakers : [DataHelperProtocol], error : SpeakerStoreError?) {
        detailObject.setRelated(speakers)
        self.details.right.reloadData()
    }
    
  
    
    
    
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            SpeakerService.sharedInstance.fetchSpeakers(self.detailObject.getRelatedIds(), completionHandler:self.callBack)
        })
        
        
        header.imageView.isHidden = true
        
        //sync with watch
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name:NSNotification.Name(rawValue: "UpdateFavorite"), object: nil)
    }
    
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UpdateFavorite"), object: nil)
    }
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let speaker = detailObject.getRelatedDetailWithIndex(indexPath.row) {
            
            
            let details = SpeakerDetailsController()
            details.delegate = self
            
            details.detailObject = speaker
     
            
           
            
            details.configure()
            details.setColor(speaker.isFavorited())
            
            self.navigationController?.pushViewController(details, animated: true)
        }
        
        
        
        
    }
    
   
    
    
    open override func twitter() {
        
        let originalString = detailObject.getTwitter()
 
        
        let escapedString = originalString?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    
    
   
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_10")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .none
        }
        
        
        
        
        
        
        cell?.textLabel?.font = UIFont(name: "Roboto", size: 15)
        cell?.textLabel?.text = detailObject.getRelatedDetailWithIndex(indexPath.row)?.getTitleD()
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
        
    }
    
    
    
    
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUpdate()
    }
    
    
    func checkCamera() {
        AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized:
            scan()
            break // Do you stuffer here i.e. allowScanning()
        case .denied: enterManually()
        default: break;
        }
    }
    
    
    open func fetchUpdate() {
        
        APIReloadManager.fetchUpdate(fetchUrl(), service: SlotService.sharedInstance, completedAction: fetchCompleted)
        
    }
    
    open func fetchCompleted(_ msg : CallbackProtocol) -> Void {
        
    }
    
   
    open func favorite(_ id : NSManagedObjectID) -> Bool {
        return TalkService.sharedInstance.invertFavorite(id)
    }
    
    open func scan() {
        let qrCodeScannerController = QRCodeScannerController()
        qrCodeScannerController.completionOnceScanned = rate
        let qrCodeNavigationController = UINavigationController(rootViewController: qrCodeScannerController)
        present(qrCodeNavigationController, animated: true, completion: nil)
    }
    
    func configurationTextField(_ textField: UITextField!) {
        
        if let tField = textField {
            txtField = tField
        }
    }
    
    func validateQrCode() {
        APIManager.setQrCode(txtField.text!)
        tryToRate()
    }
    
    open func enterManually() {
        
        let alert = UIAlertController(title: "QRCode", message: "Enter the code :", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.validateQrCode()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    open func hasBeenGranted(_ isGranted : Bool) {
        DispatchQueue.main.async(execute: {
            self.checkCamera()
        })
    }
    
    open func triggerRequestAccess() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: hasBeenGranted)
    }
    
    
    
    open func rate() {
        
        if let rateObj = detailObject as? RatableProtocol {
            
            let rateController = RateTableViewController()
            rateController.rateObject = rateObj
            let rateNavigationController = UINavigationController(rootViewController: rateController)
            present(rateNavigationController, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    open override func tryToRate() {
        
        if APIManager.qrCodeAlreadyScanned() {
            rate()
        }
        else {
            let alert = UIAlertController(title: "QRCode", message: "Please scan your badge QRCode or enter the code on your badge to authenticate yourself for presentation voting", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Scan", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.triggerRequestAccess()}))
            alert.addAction(UIAlertAction(title: "Enter manually", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.enterManually()}))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    func handleNotification(_ notification: Notification){
        invertColor()
    }
    

    
}
