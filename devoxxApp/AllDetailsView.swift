//
//  AllDetailsView.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-24.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class AllDetailsView : UIView {
    
    let simpleDetailView1 = SimpleDetailView<TopInfoDetailView>()
    let simpleDetailView2 = SimpleDetailView<TopInfoDetailView>()
    let simpleDetailView3 = SimpleDetailView<BottomInfoDetailView>()
    let simpleDetailView4 = SimpleDetailView<BottomInfoDetailView>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = UIColor.purpleColor()
        
        
        
        
        
        
        
        
        //simpleDetailView1.backgroundColor = UIColor.greenColor()
        simpleDetailView1.translatesAutoresizingMaskIntoConstraints = false
        simpleDetailView1.iconView.image = UIImage(named: "ic_place.png")?.imageWithRenderingMode(.AlwaysTemplate)
        addSubview(simpleDetailView1)
        
        
        simpleDetailView2.translatesAutoresizingMaskIntoConstraints = false
        //simpleDetailView2.backgroundColor = UIColor.blueColor()
        simpleDetailView2.iconView.image = UIImage(named: "ic_microphone.png")?.imageWithRenderingMode(.AlwaysTemplate)
        addSubview(simpleDetailView2)
        

        simpleDetailView3.translatesAutoresizingMaskIntoConstraints = false
        //simpleDetailView3.backgroundColor = UIColor.redColor()
        simpleDetailView3.iconView.image = UIImage(named: "ic_star.png")?.imageWithRenderingMode(.AlwaysTemplate)
        addSubview(simpleDetailView3)
        
        
        simpleDetailView4.translatesAutoresizingMaskIntoConstraints = false
        //simpleDetailView4.backgroundColor = UIColor.yellowColor()
        simpleDetailView4.iconView.image = UIImage(named: "ic_time.png")?.imageWithRenderingMode(.AlwaysTemplate)
        addSubview(simpleDetailView4)

        
        let views = ["simpleDetailView1": simpleDetailView1, "simpleDetailView2" : simpleDetailView2, "simpleDetailView3" : simpleDetailView3, "simpleDetailView4" : simpleDetailView4]
        
        
        let width = NSLayoutConstraint(item: simpleDetailView1,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.5,
            constant: 0)
        
        addConstraint(width)
        
        let width2 = NSLayoutConstraint(item: simpleDetailView2,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.5,
            constant: 0)
        
        let height = NSLayoutConstraint(item: simpleDetailView1,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.4,
            constant: 0)
        
        addConstraint(width)
        
        let height2 = NSLayoutConstraint(item: simpleDetailView2,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.4,
            constant: 0)

        
        let width3 = NSLayoutConstraint(item: simpleDetailView3,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.5,
            constant: 0)
        
        addConstraint(width)
        
        let width4 = NSLayoutConstraint(item: simpleDetailView4,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0.5,
            constant: 0)
        
        let height3 = NSLayoutConstraint(item: simpleDetailView3,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.6,
            constant: 0)
        
        addConstraint(width)
        
        let height4 = NSLayoutConstraint(item: simpleDetailView4,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0.6,
            constant: 0)

        
        addConstraint(width)
        addConstraint(width2)
        addConstraint(height)
        addConstraint(height2)
        
        addConstraint(width3)
        addConstraint(width4)
        addConstraint(height3)
        addConstraint(height4)
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[simpleDetailView1]-0-[simpleDetailView2]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[simpleDetailView3]-0-[simpleDetailView4]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[simpleDetailView1]-0-[simpleDetailView3]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constV2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[simpleDetailView2]-0-[simpleDetailView4]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        addConstraints(constH)
        addConstraints(constH2)
        addConstraints(constV)
        addConstraints(constV2)
        //addConstraints(constH2)
        
        
        
        
       
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
