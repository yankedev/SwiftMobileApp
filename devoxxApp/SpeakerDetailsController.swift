//
//  SpeakerDetailsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class SpeakerDetailsController : AbstractDetailsController, UITableViewDelegate, UITableViewDataSource {
    
  
    var speaker : Speaker!
  
    
    
    
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
        
        
        header.talkTitle.text = speaker.getFullName()
        header.talkTrack.text = speaker.speakerDetail.company
        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        scroll.text = speaker.speakerDetail.bio
        //scroll.backgroundColor = UIColor.yellowColor()
        
        
        configure()
 
    }
    
    
    
  
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    
   
    
    

    
    
    
    
    
    public func twitter() {
        
        let originalString = "\(APIManager.currentEvent.hashtag!) \(speaker.getFullName())"
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
        
        
        if let talk = speaker.talks.allObjects[indexPath.row] as? Talk {
            
            
            
            cell!.leftIconView.imageView.image = talk.slot.getPrimaryImage()
            
            cell!.rightTextView.topTitleView.talkTrackName.text = talk.slot.getThirdInformation()
            cell!.rightTextView.topTitleView.talkTitle.text = talk.slot.getFirstInformation()
            
            cell!.rightTextView.locationView.label.text = talk.slot.getSecondInformation()
            cell!.rightTextView.speakerView.label.text = talk.slot.getForthInformation(false)
            
            
            if let fav = talk as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.favorited())
            }

        }
        
        
        
        
        
        
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speaker.talks.count
    }

    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let talk = speaker.talks.allObjects[indexPath.row] as? Talk {
            
            let details = TalkDetailsController()
        //todo
            details.indexPath = indexPath
            details.slot = talk.slot

        
        
        
        
            details.configure()
        
            details.setColor(talk.slot.favorited())
        
            self.navigationController?.pushViewController(details, animated: true)
        }
        
    }
    
    
}