//
//  TalkDetailsController.swift
//  devoxxApp
//
//  Created by maxday on 13.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class TalkDetailsController : AbstractDetailsController, UITableViewDataSource, UITableViewDelegate, HotReloadProtocol {
    
   
    var slot : Slot!
    
    var actionButtonViewRate = ActionButtonView()


    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        let details = GobalDetailView()
        details.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(details)
        
        let views = ["header": header, "scroll" : scroll, "details" : details]

        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[header]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constH5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[details]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[header(150)]-[details(150)]-[scroll]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)

        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constH5)
        
        view.addConstraints(constV)
        

        header.talkTitle.text = slot.talk.title
        header.talkTrack.text = slot.talk.track
        scroll.text = slot.talk.summary
        

        
        details.layoutIfNeeded()
       
        details.left.simpleDetailView1.textView.firstInfo.text = "Room"
        details.left.simpleDetailView1.textView.secondInfo.text = slot.roomName
        
        details.left.simpleDetailView2.textView.firstInfo.text = "Format"
        details.left.simpleDetailView2.textView.secondInfo.text = slot.talk.getShortTalkTypeName()
        
   
        
        details.left.simpleDetailView3.textView.firstInfo.text = "Date and time"
        details.left.simpleDetailView3.textView.secondInfo.text = slot.getFriendlyTime()
        
      
        
        
        details.right.dataSource = self
        details.right.delegate = self

        
        
        
        configure()

        
        view.layoutIfNeeded()
        
        
        view.addSubview(actionButtonViewRate)
        
        let image0 = UIImage(named: "ic_twitter")?.imageWithRenderingMode(.AlwaysTemplate)
        
        actionButtonViewRate.button.setImage(image0, forState: .Normal)
        actionButtonViewRate.tintColor = UIColor.purpleColor()
        
        
        let actionButtonViewHeight = NSLayoutConstraint(item: actionButtonViewRate,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewWidth = NSLayoutConstraint(item: actionButtonViewRate,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewCenterX = NSLayoutConstraint(item: actionButtonViewRate,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 2,
            constant: -180)
        
        let actionButtonViewCenterY = NSLayoutConstraint(item: actionButtonViewRate,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 150)
        
        view.addConstraint(actionButtonViewWidth)
        view.addConstraint(actionButtonViewHeight)
        
        view.addConstraint(actionButtonViewCenterX)
        view.addConstraint(actionButtonViewCenterY)
        
        actionButtonViewRate.setup(true)
        
        
        actionButtonViewRate.button.addTarget(self, action: Selector("rate"), forControlEvents: .TouchUpInside)
        
        actionButtonViewRate.button.frame = CGRectMake(0,0,40,40)

        
    }
    
      
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
        
    
   
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRectMake(0,0,20,1000))
        label.font = UIFont(name: "Roboto", size: 15)
        label.textColor = UIColor.lightGrayColor()
        label.text = "Speakers"
        return label

        
    }
    
    
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            let speakerArray = slot.talk.speakers.sortedArrayUsingDescriptors([NSSortDescriptor(key: "firstName", ascending: true)]) as! [Speaker]
            
            let speaker = speakerArray[indexPath.row]
            
            
            
            let details = SpeakerDetailsController()
            //todo
            details.indexPath = indexPath
            details.speaker = speaker
            //details.delegate = self
            
            details.configure()
            // details.setColor(slot.favorited())
            
            self.navigationController?.pushViewController(details, animated: true)
            
            
            
        
    }
    
    public func back() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    public func twitter() {
    
        let originalString = "\(APIManager.currentEvent.hashtag!) \(slot.talk.title) by \(slot.getForthInformation(true)) \(slot.talk.getFullLink())"
        let escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    

    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Speakers"
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return slot.talk.speakers.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL_10")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_10")
            cell?.selectionStyle = .None
        }
        
        

        
        let speakerArray = slot.talk.speakers.sortedArrayUsingDescriptors([NSSortDescriptor(key: "firstName", ascending: true)]) as! [Speaker]
        
        cell?.textLabel?.font = UIFont(name: "Roboto", size: 15)
        cell?.textLabel?.text = speakerArray[indexPath.row].getFullName()
        
        cell?.accessoryType = .DisclosureIndicator
        
        return cell!
        
    }
    
    
    
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchUpdate()
    }

    
    
    
    public func fetchUpdate() {

    
        
        APIReloadManager.fetchUpdate(fetchUrl(), helper: SlotHelper(), completedAction: fetchCompleted)
        
    }
    
    public func fetchCompleted(msg : String) -> Void {
        print(self.debugDescription)
    }
    
    public func fetchUrl() -> String? {
        return "\(APIManager.currentEvent.cfpEndpoint!)/conferences/\(APIManager.currentEvent.id!)/talks/\(slot.talk.id)"
    }
    
    
    public func rate() {
        
        print("rateME")
        
        let rateViewController = RateViewController()
        
        
        rateViewController.view.frame = CGRectMake(50, 75, view.frame.size.width - 100, view.frame.size.height - 150)
        let finalCenter = rateViewController.view.center
        let origCenter = CGPointMake(finalCenter.x, 3*finalCenter.y)
        
        rateViewController.view.center = origCenter
        
        rateViewController.talkTitle.text = slot.talk.title
        rateViewController.talkSpeakers.text = slot.talk.getFriendlySpeaker(", ", useTwitter: false)
        
        
        addChildViewController(rateViewController)
        view.addSubview(rateViewController.view)
 
        
        UIView.animateWithDuration(0.5) { () -> Void in
            rateViewController.view.center = finalCenter
        }
        
    }
    
   
    
}