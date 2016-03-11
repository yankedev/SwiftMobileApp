//
//  SpeakerDetailsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class SpeakerDetailsController : AbstractDetailsController, UITableViewDelegate, UITableViewDataSource, HotReloadProtocol {
    
  
    var detailObject : DetailableProtocol!
    
    
    
    var talkList = SpeakerListView(frame: CGRectZero, style: .Grouped)
    
    
    // var speakers: UITableView!
    
  

    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
      
        view.addSubview(talkList)
        
        //talkList.backgroundColor = UIColor.redColor()
        talkList.delegate = self
        talkList.dataSource = self
        
        
        
        
        
        let views = ["header": header, "scroll" : scroll, "talkList" : talkList]
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[header]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[talkList]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[header(150)]-[scroll]-[talkList(200)]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        
        
        
        
        
        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constH3)

        
        view.addConstraints(constV)
        
        
        header.talkTitle.text = detailObject.getTitle()
        header.talkTrack.text = detailObject.getSubTitle()
        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
      //  print(speaker.speakerDetail.bio)
        scroll.text = detailObject.getSummary()
        //scroll.backgroundColor = UIColor.yellowColor()
        
        
        configure()
        
        actionButtonView2.hidden = true
 
    }
    
    
    
  
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        
        header.imageView.image = detailObject.getPrimaryImage()
    
    }
    
    
   
    
    

    
    
    
    
    
    public func twitter() {
        
        //let originalString = "\(APIManager.currentEvent.hashtag!) \(speaker.displayTwitter())"
        
        let originalString = ""
        
        let escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    

    
    //DATASOUTCE
    
    
    public func back() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRectMake(0,0,20,1000))
        label.font = UIFont(name: "Roboto", size: 18)
        label.textColor = UIColor.lightGrayColor()
        label.text = "Talks"
        return label
        
        
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10") as? ScheduleCellView
        
        if cell == nil {
            cell = ScheduleCellView(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
   
        }
        /*
        
        if let talk = speaker.talks.allObjects[indexPath.row] as? Talk {
            
            
            
            cell!.leftIconView.imageView.image = talk.getPrimaryImage()
            
            cell!.rightTextView.topTitleView.talkTrackName.text = talk.getThirdInformation()
            cell!.rightTextView.topTitleView.talkTitle.text = talk.getFirstInformation()
            
            cell!.rightTextView.locationView.label.text = talk.getSecondInformation()
            cell!.rightTextView.speakerView.label.text = talk.getForthInformation(false)
            
            
            if let fav = talk as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.isFav())
            }

        }
        
        */
        
        
        
        
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        //return speaker.talks.count
    }

    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if let talk = speaker.talks.allObjects[indexPath.row] as? Talk {
            
            let details = TalkDetailsController()
        //todo
            //details.indexPath = indexPath
            details.slot = talk.slot

        
        
        
        
            details.configure()
        
            details.setColor(talk.isFav())
        
            self.navigationController?.pushViewController(details, animated: true)
        }
        */
    }
    
    
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchUpdate()
    }
    
    
    
    
    public func fetchUpdate() {
    
        
        APIReloadManager.fetchUpdate(fetchUrl(), helper: SpeakerDetailHelper(), completedAction: fetchCompleted)
        //APIReloadManager.fetchSpeakerImg(speaker.getUrl(), id: speaker.objectID, completedAction: fetchCompleted)
    }
    
    public func fetchCompleted(msg : String) -> Void {
       
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!

        //speaker = APIDataManager.findEntityFromId(speaker.objectID, context: context)
        
        scroll.text = detailObject.getSummary()
        header.talkTrack.text = detailObject.getSubTitle()
        header.imageView.image = detailObject.getPrimaryImage()
        
    }
    
    public func fetchUrl() -> String? {
        //return speaker.href
        return ""
    }

    
    
}