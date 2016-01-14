//
//  ScheduleViewCell.swift
//  devoxxApp
//
//  Created by maxday on 11.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//


import Foundation
import UIKit
import QuartzCore

class ScheduleViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var trackImg:UIImageView!
    var btnFavorite:UIButton!
    var talkType:UILabel!
    var talkTitle:UILabel!
    var talkRoom:UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
        //backgroundColor = UIColor.yellowColor()
        
        let infoView = UIView()
        //infoView.backgroundColor = UIColor.redColor()
        infoView.translatesAutoresizingMaskIntoConstraints = false
        let talkView = UIView()
        //talkView.backgroundColor = UIColor.blueColor()
        talkView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(talkView)
        addSubview(infoView)
        
        let viewsDictionary = ["info":infoView,"talk":talkView]
        
        let layout = NSLayoutFormatOptions(rawValue: 0)
        
        let horizontalContraint:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[info(40)]-5-[talk]-5-|", options: layout, metrics: nil, views: viewsDictionary)
        
        
        
        let verticalContraint_1:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[info]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let verticalContraint_2:[NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[talk]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(verticalContraint_1)
        self.addConstraints(verticalContraint_2)
        self.addConstraints(horizontalContraint)
        
        trackImg = UIImageView()
        trackImg.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(trackImg)
        
        talkType = UILabel()
        talkType.translatesAutoresizingMaskIntoConstraints = false
        talkType.font = UIFont(name: "Roboto", size: 6)
        talkType.textAlignment = .Center
        talkType.layer.masksToBounds = true;
        talkType.layer.cornerRadius = 3.0;
        infoView.addSubview(talkType)
        
        
        talkTitle = UILabel()
        talkTitle.translatesAutoresizingMaskIntoConstraints = false
        talkTitle.font = UIFont(name: "Roboto", size: 14)
        //talkTitle.backgroundColor = UIColor.purpleColor()
        talkView.addSubview(talkTitle)
        
        
        talkRoom = UILabel()
        talkRoom.translatesAutoresizingMaskIntoConstraints = false
        talkRoom.font = UIFont(name: "Roboto", size: 8)
        //talkRoom.backgroundColor = UIColor.greenColor()
        talkView.addSubview(talkRoom)
        
        
        
        
        
        
        
        
        let widthTalkTitleConstraint = NSLayoutConstraint(item: talkTitle, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: talkView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        widthTalkTitleConstraint.identifier = "widthTalkTitleConstraint"
        
        let heightTalkTitleConstraint = NSLayoutConstraint(item: talkTitle, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: talkView, attribute: NSLayoutAttribute.Height, multiplier: 0.7, constant: 0)
        heightTalkTitleConstraint.identifier = "heightTalkTitleConstraint"
        
        let topTalkTitleConstraint = NSLayoutConstraint(item: talkTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: talkView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        topTalkTitleConstraint.identifier = "topTalkTitleConstraint"
        
        let leadingTalkTitleConstraint = NSLayoutConstraint(item: talkTitle, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: talkView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        leadingTalkTitleConstraint.identifier = "leadingTalkTitleConstraint"
        
        
        talkView.addConstraint(widthTalkTitleConstraint)
        talkView.addConstraint(heightTalkTitleConstraint)
        talkView.addConstraint(topTalkTitleConstraint)
        talkView.addConstraint(leadingTalkTitleConstraint)
        
        
        
        
        
        /*
        
        
        
        */
        
        
        
        
        
        
        let topTalkRoomConstraint = NSLayoutConstraint(item: talkRoom, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: talkRoom.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 0.7, constant: 0)
        topTalkRoomConstraint.identifier = "topTalkRoomConstraint"
        
        
        let heightTalkRoomConstraint = NSLayoutConstraint(item: talkRoom, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: talkView, attribute: NSLayoutAttribute.Height, multiplier: 0.3, constant: 0)
        heightTalkRoomConstraint.identifier = "heightTalkRoomConstraint"
        
        let widthTalkRoomConstraint = NSLayoutConstraint(item: talkRoom, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: talkRoom.superview, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        widthTalkRoomConstraint.identifier = "widthTalkRoomConstraint"
        
        
        let leadingTalkRoomConstraint = NSLayoutConstraint(item: talkRoom, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: talkView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        leadingTalkRoomConstraint.identifier = "leadingTalkRoomConstraint"
        
        
        talkView.addConstraint(widthTalkRoomConstraint)
        talkView.addConstraint(heightTalkRoomConstraint)
        talkView.addConstraint(topTalkRoomConstraint)
        talkView.addConstraint(leadingTalkRoomConstraint)
        
        
        
        
        
        // constraints
        
        
        let topTrackImgConstraint = NSLayoutConstraint(item: trackImg, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: trackImg.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 0.1, constant: 0)
        topTrackImgConstraint.identifier = "topTrackImgConstraint"
        
        
        let heightTrackImgConstraint = NSLayoutConstraint(item: trackImg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: trackImg.superview, attribute: NSLayoutAttribute.Width, multiplier: 0.6, constant: 0)
        heightTrackImgConstraint.identifier = "heightTrackImgConstraint"
        
        let widthTrackImgConstraint = NSLayoutConstraint(item: trackImg, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: trackImg.superview, attribute: NSLayoutAttribute.Width, multiplier: 0.6, constant: 0)
        widthTrackImgConstraint.identifier = "widthTrackImgConstraint"
    
        
        let centerXTrackImgConstraint = NSLayoutConstraint(item: trackImg, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: trackImg.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        centerXTrackImgConstraint.identifier = "centerXTrackImgConstraint"
        
        infoView.addConstraint(centerXTrackImgConstraint)
        
        
        infoView.addConstraint(topTrackImgConstraint)
        infoView.addConstraint(heightTrackImgConstraint)
        infoView.addConstraint(widthTrackImgConstraint)


        
        let topTalkTypeConstraint = NSLayoutConstraint(item: talkType, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: talkType.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 0.7, constant: 0)
        topTalkTypeConstraint.identifier = "topTalkTypeConstraint"
        
        
        let heightTalkTypeConstraint = NSLayoutConstraint(item: talkType, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: talkType.superview, attribute: NSLayoutAttribute.Width, multiplier: 0.2, constant: 0)
        heightTalkTypeConstraint.identifier = "heightTalkTypeConstraint"
        
        let widthTalkTypeConstraint = NSLayoutConstraint(item: talkType, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: talkType.superview, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        widthTalkTypeConstraint.identifier = "widthTalkTypeConstraint"
        
        
        let leadingTalkTypeConstraint = NSLayoutConstraint(item: talkType, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: talkType.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        leadingTalkTypeConstraint.identifier = "leadingTalkTypeConstraint"
        
        
        
        infoView.addConstraint(topTalkTypeConstraint)
        infoView.addConstraint(heightTalkTypeConstraint)
        infoView.addConstraint(widthTalkTypeConstraint)
        infoView.addConstraint(leadingTalkTypeConstraint)

        
    }
    
    func updateBackgroundColor(isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    func hideFavorite(animated animated : Bool) {
        //scrollView.scrollRectToVisible(CGRectMake(50, 1, 380, 50), animated: animated)
    }
    
    func showFavorite() {
        //scrollView.scrollRectToVisible(CGRectMake(0, 0, 380, 50), animated: true)
    }
    
    /*
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.delegate.beginScroll(self)
    }
    */
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        /* if(decelerate) {
        return
        }
        
        if(scrollView.contentOffset.x < leftOffset/2) {
        showFavorite()
        }
        else {
        hideFavorite(animated: true)
        }*/
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView.contentOffset.x == 0) {
            //scrollView.userInteractionEnabled = true
        }
        else {
            //scrollView.userInteractionEnabled = false
        }
    }
    
    
    
    
    
    
}
