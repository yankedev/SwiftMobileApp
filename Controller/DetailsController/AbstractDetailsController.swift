//
//  AbstractDetailsController.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

public class AbstractDetailsController : UIViewController {
    
    var scroll : UITextView!
    var detailObject : DetailableProtocol!
    var header = ColoredHeaderView(frame: CGRectZero)
    
    weak var delegate : FavoritableProtocol!
    
    var actionButtonView2 = ActionButtonView()
    var actionButtonView1 = ActionButtonView()
    var actionButtonView0 = ActionButtonView()
    var actionButtonViewBack = ActionButtonView()
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scroll = UITextView()
        scroll.backgroundColor = UIColor.whiteColor()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.whiteColor()
        scroll.font = UIFont(name: "Roboto", size:  18)
        scroll.editable = false
        
        
        let inputImage = UIImage(named: "talk_background.png")
        header.image = inputImage
        
        
        view.addSubview(header)
        view.addSubview(scroll)
        
        view.addSubview(actionButtonViewBack)
        view.addSubview(actionButtonView0)
        view.addSubview(actionButtonView1)
        view.addSubview(actionButtonView2)
        
        
        actionButtonViewBack.setup(false)
        let imageBack = UIImage(named: "ic_back")?.imageWithRenderingMode(.AlwaysTemplate)
        actionButtonViewBack.button.setImage(imageBack, forState: .Normal)
        actionButtonViewBack.tintColor = UIColor.whiteColor()
        
        
        
        let image0 = UIImage(named: "ic_twitter")?.imageWithRenderingMode(.AlwaysTemplate)
        actionButtonView0.button.setImage(image0, forState: .Normal)
        actionButtonView0.tintColor = UIColor.whiteColor()
        actionButtonView0.setup(true)
        
        
        
        let image1 = UIImage(named: "ic_star")?.imageWithRenderingMode(.AlwaysTemplate)
        actionButtonView1.button.setImage(image1, forState: .Normal)
        actionButtonView1.tintColor = UIColor.whiteColor()
        actionButtonView1.setup(true)
        
        let image2 = UIImage(named: CfpService.sharedInstance.getVotingImage())
        actionButtonView2.button.setImage(image2, forState: .Normal)
        actionButtonView2.setup(true)
        
        actionButtonViewBack.button.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
        
        view.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        //
        let actionButtonViewHeight = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewWidth = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewCenterX = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 2,
            constant: -95)
        
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
            constant: 45)
        
        let actionButtonViewWidth1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 45)
        
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
        
        
        
        let actionButtonViewHeight2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Height,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewWidth2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewCenterX2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 2,
            constant: -150)
        
        let actionButtonViewCenterY2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 150)
        
        view.addConstraint(actionButtonViewWidth2)
        view.addConstraint(actionButtonViewHeight2)
        
        view.addConstraint(actionButtonViewCenterX2)
        view.addConstraint(actionButtonViewCenterY2)
        
        
        
        
        
        
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
        
        let actionButtonViewBackTop = NSLayoutConstraint(item: actionButtonViewBack,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 10)
        
        view.addConstraint(actionButtonViewBackHeight)
        view.addConstraint(actionButtonViewBackWidth)
        view.addConstraint(actionButtonViewBackTop)
        
        
        
        view.layoutIfNeeded()
        
        actionButtonView1.button.addTarget(self, action: Selector("clicked"), forControlEvents: .TouchUpInside)
        
        
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        header.imageView.image = detailObject?.getPrimaryImage()
    }
    
    
    public func setColor(isFavorited: Bool) {
        if isFavorited {
            actionButtonView1.button.tintColor = ColorManager.grayImageColor
        }
        else {
            actionButtonView1.button.tintColor = UIColor.whiteColor()
        }
    }
    
    
    public func configure() {
        
        actionButtonView0.button.addTarget(self, action: Selector("twitter"), forControlEvents: .TouchUpInside)
        
        actionButtonView2.button.addTarget(self, action: Selector("tryToRate"), forControlEvents: .TouchUpInside)
        
        actionButtonViewBack.button.addTarget(self, action: Selector("back"), forControlEvents: .TouchUpInside)
        
        actionButtonViewBack.setup(false)
        actionButtonView0.setup(true)
        actionButtonView1.setup(true)
        actionButtonView2.setup(true)
        
        view.bringSubviewToFront(actionButtonViewBack)
        view.bringSubviewToFront(actionButtonView0)
        view.bringSubviewToFront(actionButtonView1)
        view.bringSubviewToFront(actionButtonView2)
        
        
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRectMake(0,0,20,1000))
        label.font = UIFont(name: "Roboto", size: 15)
        label.textColor = UIColor.lightGrayColor()
        label.text = detailObject.getHeaderTitle()
        return label
        
        
    }

    
    
    public func clicked() {
        if delegate != nil {
            let response = delegate.favorite(detailObject.getObjectID()!)
            setColor(response)
        }
    }
    
    public func back() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailObject.getRelatedDetailsCount()
    }
    
    
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    public func fetchUrl() -> String? {
        //todo
        return ""
    }
   
    
    
    
    
}