//
//  HeaderView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-21.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit


class HeaderView : UIView {


    var upDown : UIButton!
    var headerString : UILabel!
    var numberOfTalkString : UILabel!
    var eventImg : UIImageView!
    
    override init(frame : CGRect) {
        super.init(frame: frame)
    
        backgroundColor = UIColor.whiteColor()
        
      
        //headerView.tag = section
        
        headerString = UILabel(frame: CGRect(x: 10, y: 10, width: frame.size.width-10, height: 30)) as UILabel
        headerString.textColor = ColorManager.topNavigationBarColor
        addSubview(headerString)
        
        numberOfTalkString = UILabel(frame: CGRect(x: 180, y: 10, width: frame.size.width-180, height: 30)) as UILabel
        numberOfTalkString.textColor = UIColor.darkGrayColor()
        
        eventImg = UIImageView(frame: CGRect(x: 155, y: 14, width: 18, height: 20))
        eventImg.image = UIImage(named: "event.png")
        
        addSubview(numberOfTalkString)
        
        upDown = UIButton(frame: CGRect(x: 330, y: 17, width: 119/4, height: 62/4))
        upDown.setImage(UIImage(named: "down.png"), forState: .Normal)
        upDown.setImage(UIImage(named: "up.png"), forState: .Selected)

            
        addSubview(upDown)
        addSubview(eventImg)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}