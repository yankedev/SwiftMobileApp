//
//  SpeakerDetailsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class SpeakerDetailsController : UIViewController, UITableViewDelegate, UITableViewDataSource, HotReloadProtocol, FavoritableProtocol {
    
    @IBOutlet var talkList: UITableView!
    @IBOutlet var scroll: UITextView!
    @IBOutlet var header: UIView!
    //var talkList = SpeakerListView(frame: CGRectZero, style: .Grouped)
    
    @IBOutlet var talkTitle: UILabel!
    @IBOutlet var talkTrack: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var star: UIView!
    @IBOutlet var tweet: UIView!
    
    @IBOutlet var starBtn: UIButton!
    @IBOutlet var tweetBtn: UIButton!
    
    var detailObject : DetailableProtocol!
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        //view.addSubview(talkList)
        
        //talkList.backgroundColor = UIColor.redColor()
        talkList.delegate = self
        talkList.dataSource = self
        
 
        talkTitle.text = detailObject.getTitle()
        talkTrack.text = detailObject.getSubTitle()
        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        scroll.text = detailObject.getSummary()
        //scroll.backgroundColor = UIColor.yellowColor()
        
        imageView.layer.cornerRadius = 70 / 2
        imageView.layer.masksToBounds = true
        imageView.image = detailObject.getPrimaryImage()
        
        
        tweet.backgroundColor = ColorManager.topNavigationBarColor
        tweet.layer.cornerRadius = tweet.frame.size.width / 2
        
        star.backgroundColor = ColorManager.topNavigationBarColor
        star.layer.cornerRadius = star.frame.size.width / 2
        
        //configure()
        
        //actionButtonView2.hidden = true
        
        
        
        
        let image0 = UIImage(named: "ic_twitter")?.imageWithRenderingMode(.AlwaysTemplate)
        tweetBtn.setImage(image0, forState: .Normal)
        tweetBtn.tintColor = UIColor.whiteColor()
       

        let image1 = UIImage(named: "ic_star")?.imageWithRenderingMode(.AlwaysTemplate)
        starBtn.setImage(image1, forState: .Normal)
        starBtn.tintColor = UIColor.whiteColor()
        
        
      
        
        TalkService.sharedInstance.fetchTalks(detailObject.getRelatedIds(), completionHandler: callBack)
    }
    
    
    
    func callBack(talks : [DataHelperProtocol], error : TalksStoreError?) {
        detailObject.setRelated(talks)
        talkList.reloadData()
    }
    

    
    public func twitter() {
        
        let originalString = detailObject.getTwitter()
     
        
        let escapedString = originalString?.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    
    
    //DATASOUTCE
    
    
    
    
   
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10") as? ScheduleCellView
        
        if cell == nil {
            cell = ScheduleCellView(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            
        }
        
        
        if let relatedObject = detailObject.getRelatedDetailWithIndex(indexPath.row) {
            
            
        
            //cell!.imageView.image = relatedObject.getPrimaryImage()
            
            cell!.rightTextView.topTitleView.talkTrackName.text = relatedObject.getDetailInfoWithIndex(2)
            cell!.rightTextView.topTitleView.talkTitle.text = relatedObject.getTitle()
            
            cell!.rightTextView.locationView.label.text = relatedObject.getDetailInfoWithIndex(0)
            cell!.rightTextView.speakerView.label.text = relatedObject.getDetailInfoWithIndex(3)
            
            
            
            if let fav = relatedObject as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.isFav())
            }
            
        }
        
        
        
        
        
        
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
    }
    
  
    public func favorite(id : NSManagedObjectID) -> Bool {
        return SpeakerService.sharedInstance.invertFavorite(id)
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let talk = detailObject.getRelatedDetailWithIndex(indexPath.row) {
            
            let details = TalkDetailsController()
            details.delegate = self
            details.detailObject = talk
            
            details.configure()
            
            details.setColor(talk.isFavorited())
        
            
            self.navigationController?.pushViewController(details, animated: true)
        }
        
    }
    
    
    
    func callBackTalks(talks : [DataHelperProtocol], error : TalksStoreError?) {
        detailObject.setRelated(talks)
        talkList.reloadData()
    }
    


    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchUpdate()
        talkList.reloadData()
    }
    

    public func fetchUpdate() {
        APIReloadManager.fetchUpdate(detailObject.getFullLink(), service: SpeakerDetailService.sharedInstance, completedAction: fetchCompleted)
        
        APIReloadManager.fetchImg(detailObject.getImageFullLink(), id : detailObject.getObjectID(), service:SpeakerService.sharedInstance, completedAction: callbackImg)
    }
   
    public func fetchCompleted(newHelper : CallbackProtocol) -> Void {
    
        if let newDetailObject = newHelper.getHelper() as? DetailableProtocol {
            detailObject = newDetailObject
        }
        scroll.text = detailObject.getSummary()
        talkTrack.text = detailObject.getSubTitle()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            TalkService.sharedInstance.fetchTalks(self.detailObject.getRelatedIds(), completionHandler:self.callBackTalks)
        })
   }
    
    public func callbackImg(newHelper : CallbackProtocol) {
        if let newDetailObjectData = newHelper.getImg() {
            imageView.backgroundColor = UIColor.redColor()
            imageView.image = UIImage(data: newDetailObjectData)
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