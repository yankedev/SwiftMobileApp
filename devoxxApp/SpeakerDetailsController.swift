//
//  SpeakerDetailsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class SpeakerDetailsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var scroll : UITextView!
    var speaker : Speaker!
    var header = ColoredHeaderView(frame: CGRectZero)
    
    
    
    var talkList = SpeakerListView(frame: CGRectZero, style: .Grouped)
    
    
    // var speakers: UITableView!
    
    var indexPath: NSIndexPath!
    var delegate : DevoxxAppFavoriteDelegate!
    
    
    var actionButtonView1 = ActionButtonView()
    var actionButtonView0 = ActionButtonView()
    var actionButtonViewBack = ActionButtonView()
    
    
    override public func viewDidLoad() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        scroll = UITextView()
        scroll.backgroundColor = UIColor.whiteColor()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.whiteColor()
        
        
        talkList.backgroundColor = UIColor.whiteColor()
        
        
        
        let inputImage = UIImage(named: "talk_background.png")
        header.image = inputImage
        
        
        
        
        
        
        
        
        
        view.addSubview(header)
        view.addSubview(scroll)
        view.addSubview(talkList)
        
        //talkList.backgroundColor = UIColor.redColor()
        talkList.delegate = self
        talkList.dataSource = self
        
        
        view.addSubview(actionButtonViewBack)
        view.addSubview(actionButtonView0)
        view.addSubview(actionButtonView1)

        
        
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
        
        
        
        
        
        scroll.font = UIFont(name: "Roboto", size:  18)
        
        scroll.editable = false
        
        
        
        
        let actionButtonViewHeight = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewWidth = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewCenterX = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 2,
            constant: -110)
        
        let actionButtonViewCenterY = NSLayoutConstraint(item: actionButtonView0,
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
        
        
        let actionButtonViewHeight1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewWidth1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewCenterX1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 2,
            constant: -40)
        
        let actionButtonViewCenterY1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 150)
        
        view.addConstraint(actionButtonViewWidth1)
        view.addConstraint(actionButtonViewHeight1)
        
        view.addConstraint(actionButtonViewCenterX1)
        view.addConstraint(actionButtonViewCenterY1)
        
        
        
        
        let actionButtonViewBackHeight = NSLayoutConstraint(item: actionButtonViewBack,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewBackWidth = NSLayoutConstraint(item: actionButtonViewBack,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 60)
        
        view.addConstraint(actionButtonViewBackHeight)
        view.addConstraint(actionButtonViewBackWidth)
        view.layoutIfNeeded()
        
        
        actionButtonViewBack.setup(false)
        let imageBack = UIImage(named: "ic_back")?.imageWithRenderingMode(.AlwaysTemplate)
        actionButtonViewBack.button.setImage(imageBack, forState: .Normal)
        actionButtonViewBack.tintColor = UIColor.whiteColor()
        
        
        actionButtonView0.setup(true)
        let image0 = UIImage(named: "ic_twitter")?.imageWithRenderingMode(.AlwaysTemplate)
        actionButtonView0.button.setImage(image0, forState: .Normal)
        actionButtonView0.tintColor = UIColor.whiteColor()
        
        
        actionButtonView1.setup(true)
        let image1 = UIImage(named: "ic_star")?.imageWithRenderingMode(.AlwaysTemplate)
        actionButtonView1.button.setImage(image1, forState: .Normal)
        actionButtonView1.tintColor = UIColor.whiteColor()
        

        
        actionButtonView0.button.addTarget(self, action: Selector("twitter"), forControlEvents: .TouchUpInside)
        actionButtonView1.button.addTarget(self, action: Selector("clicked"), forControlEvents: .TouchUpInside)
        
        actionButtonViewBack.button.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)

 
    }
    
  
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    public func clicked() {
        //let response = delegate.favorite(indexPath)
        //setColor(response)
    }
    
    public func setColor(isFavorited: Bool) {
        if isFavorited {
            actionButtonView1.button.tintColor = ColorManager.grayImageColor
        }
        else {
            actionButtonView1.button.tintColor = UIColor.blackColor()
        }
    }
    
    public func configure() {
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setBackgroundImage(UIImage(named: "StarOn"), forState: UIControlState.Selected)
        button.setBackgroundImage(UIImage(named: "StarOff"), forState: UIControlState.Normal)
      
    }
    
    

    
    
    
    
    public func back() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    public func twitter() {
        
        let originalString = "\(APIManager.currentEvent.hashtag!) \(speaker.getFullName())"
        let escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    

    
    //DATASOUTCE
    
    
    
    
    
    
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