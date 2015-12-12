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

class ScheduleViewCell: UITableViewCell {
    
    var imgView:UIImageView!
    var btnFavorite:UIButton!
    var trackLabel:UILabel!
    var talkTitle:UILabel!
    var talkRoom:UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        
        imgView = UIImageView(frame: CGRectMake(22, 0, 25, 25))
        addSubview(imgView)
        
        trackLabel = UILabel(frame: CGRectMake(10, 27, 50, 10))
        trackLabel.font = UIFont(name: "Roboto", size: 8)
        trackLabel.textAlignment = .Center
        trackLabel.layer.masksToBounds = true;
        trackLabel.layer.cornerRadius = 3.0;
        addSubview(trackLabel)
        
        talkTitle = UILabel(frame: CGRect(x: 75, y: 0, width: 257, height: 30))
        talkTitle.font = UIFont(name: "Roboto", size: 14)
        addSubview(talkTitle)
        
        talkRoom = UILabel(frame: CGRect(x: 75, y: 30, width: 257, height: 10))
        talkRoom.font = UIFont(name: "Roboto", size: 8)
        addSubview(talkRoom)
        
        let image = UIImage(named: "favoriteOn")
        btnFavorite = UIButton(frame: CGRectMake(330, 10, 20, 20))
        btnFavorite.setImage(image, forState: .Normal)
        btnFavorite.addTarget(self, action: "btnTouched", forControlEvents:.TouchUpInside)
        btnFavorite.alpha = 0.2

    }
    
    func btnTouched() {
        btnFavorite.selected = !btnFavorite.selected
    }
    
}
