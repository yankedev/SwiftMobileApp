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


protocol ScheduleViewCellDelegate : NSObjectProtocol {
    func beginScroll(sender: ScheduleViewCell) -> Void
}

class ScheduleViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var imgView:UIImageView!
    var btnFavorite:UIButton!
    var trackLabel:UILabel!
    var talkTitle:UILabel!
    var talkRoom:UILabel!
    
    var delegate: ScheduleViewCellDelegate!
    
    var indexPath:NSIndexPath!
    
    var scrollView:UIScrollView!
    
    let leftOffset:CGFloat = 50.0
    
    var current = false
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, 380, 50))
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.backgroundColor = UIColor.blueColor()
        scrollView.contentSize = CGSizeMake(scrollView.frame.width + 50, scrollView.frame.height)
        
        
        
        
        self.contentView.addSubview(scrollView)
        
        self.contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        
        imgView = UIImageView(frame: CGRectMake(22 + leftOffset, 5, 25, 25))
        scrollView.addSubview(imgView)
        
        trackLabel = UILabel(frame: CGRectMake(10 + leftOffset, 33, 50, 10))
        trackLabel.font = UIFont(name: "Roboto", size: 8)
        trackLabel.textAlignment = .Center
        trackLabel.layer.masksToBounds = true;
        trackLabel.layer.cornerRadius = 3.0;
        scrollView.addSubview(trackLabel)
        
        talkTitle = UILabel(frame: CGRect(x: 75 + leftOffset, y: 0, width: 257, height: 30))
        talkTitle.font = UIFont(name: "Roboto", size: 14)
        scrollView.addSubview(talkTitle)
        
        talkRoom = UILabel(frame: CGRect(x: 75 + leftOffset, y: 30, width: 257, height: 10))
        talkRoom.font = UIFont(name: "Roboto", size: 8)
        scrollView.addSubview(talkRoom)
        
        scrollView.userInteractionEnabled = false
       
        
        scrollView.scrollRectToVisible(CGRectMake(50, 1, 380, 50), animated: false)
        scrollView.bounces = false
        
        scrollView.delegate = self
        
        let blueSquare = UIView(frame : CGRectMake(0, 0, 50, 50))
        //blueSquare.backgroundColor = UIColor.blueColor()
        
        
        let imageOn = UIImage(named: "favoriteOn")
        let imageOff = UIImage(named: "favoriteOff")
        btnFavorite = UIButton(frame: CGRectMake(10, 10, 30, 30))
        btnFavorite.setImage(imageOff, forState: .Normal)
        btnFavorite.setImage(imageOn, forState: .Selected)
        
       

        blueSquare.addSubview(btnFavorite)
        
        scrollView.addSubview(blueSquare)
        

    }
    
    func updateBackgroundColor() {
        if(btnFavorite.selected) {
            scrollView.backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            scrollView.backgroundColor = UIColor.whiteColor()
        }

    }

    func hideFavorite(#animated : Bool) {
        print("hide favorite")
        println(scrollView.userInteractionEnabled)
        //scrollView.userInteractionEnabled = false
        scrollView.scrollRectToVisible(CGRectMake(50, 1, 380, 50), animated: animated)
    }

    func showFavorite() {
        print("show favorite")
        println(scrollView.userInteractionEnabled)
        //scrollView.userInteractionEnabled = true
        scrollView.scrollRectToVisible(CGRectMake(0, 0, 380, 50), animated: true)
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.delegate.beginScroll(self)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(decelerate) {
            return
        }
        
        if(scrollView.contentOffset.x < leftOffset/2) {
            showFavorite()
        }
        else {
            hideFavorite(animated: true)
        }
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
