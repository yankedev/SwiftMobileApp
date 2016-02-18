//
//  ScheduleControllerView.swift
//  devoxxApp
//
//  Created by maxday on 22.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit


protocol TopFilterableProtocol {
    var filterRightButton:UIBarButtonItem { get set }
}

class ScheduleControllerView : UIView, TopFilterableProtocol {
    
    var favoriteSwitcher:UIBarButtonItem
    var filterRightButton:UIBarButtonItem
    
    var backLeftButton:UIBarButtonItem
    

    
    init(target: AnyObject?, filterSelector:Selector, favoriteSelector:Selector, backTarget: AnyObject?, backSelector:Selector) {
        
        
        let img = UIImage(named: "filterWhite.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        filterRightButton = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: target, action: filterSelector)
        
        favoriteSwitcher = UIBarButtonItem(barButtonSystemItem: .Compose, target: target, action: favoriteSelector)

        
        backLeftButton = UIBarButtonItem(barButtonSystemItem: .Reply, target: backTarget, action: backSelector)
        
        
       
        
        
        
        super.init(frame: CGRectZero)
        self.initialize()
    }
    
    
    override init(frame: CGRect) {
        self.filterRightButton = UIBarButtonItem()
        self.favoriteSwitcher = UIBarButtonItem()
        self.backLeftButton = UIBarButtonItem()
        
        super.init(frame: frame)
        self.initialize()
    }

    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        backgroundColor = ColorManager.bottomDotsPageController
    }
    
    
    
}