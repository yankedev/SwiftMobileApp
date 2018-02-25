//
//  AbstractDetailsController.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

open class AbstractDetailsController : UIViewController {
    
    var scroll : UITextView!
    var detailObject : DetailableProtocol!
    var header = ColoredHeaderView(frame: CGRect.zero)
    
    weak var delegate : FavoritableProtocol!
    
    var actionButtonView2 = ActionButtonView()
    var actionButtonView1 = ActionButtonView()
    var actionButtonView0 = ActionButtonView()
    var actionButtonViewBack = ActionButtonView()
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scroll = UITextView()
        scroll.backgroundColor = UIColor.white
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.white
        scroll.font = UIFont(name: "Roboto", size:  18)
        scroll.isEditable = false
        
        
        let inputImage = UIImage(named: "talk_background.png")
        header.image = inputImage
        
        
        view.addSubview(header)
        view.addSubview(scroll)
        
        view.addSubview(actionButtonViewBack)
        view.addSubview(actionButtonView0)
        view.addSubview(actionButtonView1)
        view.addSubview(actionButtonView2)
        
        
        actionButtonViewBack.setup(false)
        let imageBack = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)
        actionButtonViewBack.button.setImage(imageBack, for: UIControlState())
        actionButtonViewBack.tintColor = UIColor.white
        
        
        
        let image0 = UIImage(named: "ic_twitter")?.withRenderingMode(.alwaysTemplate)
        actionButtonView0.button.setImage(image0, for: UIControlState())
        actionButtonView0.tintColor = UIColor.white
        actionButtonView0.setup(true)
        
        
        
        let image1 = UIImage(named: "ic_time")?.withRenderingMode(.alwaysTemplate)
        actionButtonView1.button.setImage(image1, for: UIControlState())
        actionButtonView1.tintColor = UIColor.white
        actionButtonView1.setup(true)
        
        if CfpService.sharedInstance.getVotingImage() == "ic_thee" {
            actionButtonView2.isHidden = true
        }
        else {
            let image2 = UIImage(named: CfpService.sharedInstance.getVotingImage())?.withRenderingMode(.alwaysTemplate)
            actionButtonView2.button.setImage(image2, for: UIControlState())
            actionButtonView2.tintColor = UIColor.white
            actionButtonView2.setup(true)
        }
        
        actionButtonViewBack.button.addTarget(self, action: #selector(AbstractDetailsController.back), for: .touchUpInside)
        
        view.backgroundColor = UIColor.white
        
        
        
        
        
        //
        let actionButtonViewHeight = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.height,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewWidth = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.width,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewCenterX = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 2,
            constant: -95)
        
        let actionButtonViewCenterY = NSLayoutConstraint(item: actionButtonView0,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: 150)
        
        view.addConstraint(actionButtonViewWidth)
        view.addConstraint(actionButtonViewHeight)
        
        view.addConstraint(actionButtonViewCenterX)
        view.addConstraint(actionButtonViewCenterY)
        
        
        let actionButtonViewHeight1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.height,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewWidth1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.width,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewCenterX1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 2,
            constant: -40)
        
        let actionButtonViewCenterY1 = NSLayoutConstraint(item: actionButtonView1,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: 150)
        
        view.addConstraint(actionButtonViewWidth1)
        view.addConstraint(actionButtonViewHeight1)
        
        view.addConstraint(actionButtonViewCenterX1)
        view.addConstraint(actionButtonViewCenterY1)
        
        
        
        let actionButtonViewHeight2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.height,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewWidth2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.width,
            multiplier: 0,
            constant: 45)
        
        let actionButtonViewCenterX2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 2,
            constant: -150)
        
        let actionButtonViewCenterY2 = NSLayoutConstraint(item: actionButtonView2,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: 150)
        
        view.addConstraint(actionButtonViewWidth2)
        view.addConstraint(actionButtonViewHeight2)
        
        view.addConstraint(actionButtonViewCenterX2)
        view.addConstraint(actionButtonViewCenterY2)
        
        
        
        
        
        
        let actionButtonViewBackHeight = NSLayoutConstraint(item: actionButtonViewBack,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.height,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewBackWidth = NSLayoutConstraint(item: actionButtonViewBack,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.width,
            multiplier: 0,
            constant: 60)
        
        let actionButtonViewBackTop = NSLayoutConstraint(item: actionButtonViewBack,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.top,
            multiplier: 1,
            constant: 10)
        
        view.addConstraint(actionButtonViewBackHeight)
        view.addConstraint(actionButtonViewBackWidth)
        view.addConstraint(actionButtonViewBackTop)
        
        
        
        view.layoutIfNeeded()
        
        actionButtonView1.button.addTarget(self, action: #selector(self.clicked), for: .touchUpInside)
        
        
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        header.imageView.image = detailObject?.getPrimaryImage()
    }
    
    
    open func setColor(_ isFavorited: Bool) {
        if isFavorited {
            actionButtonView1.button.tintColor = ColorManager.grayImageColor
        }
        else {
            actionButtonView1.button.tintColor = UIColor.white
        }
    }

    
    open func invertColor() {
        if actionButtonView1.button.tintColor == ColorManager.grayImageColor {
            actionButtonView1.button.tintColor = UIColor.white
        }
        else {
            actionButtonView1.button.tintColor = ColorManager.grayImageColor
        }
    }

    
    open func configure() {
        
        actionButtonView0.button.addTarget(self, action: #selector(AbstractDetailsController.twitter), for: .touchUpInside)
        
        actionButtonView2.button.addTarget(self, action: #selector(AbstractDetailsController.tryToRate), for: .touchUpInside)
        
        actionButtonViewBack.button.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        
        actionButtonViewBack.setup(false)
        actionButtonView0.setup(true)
        actionButtonView1.setup(true)
        actionButtonView2.setup(true)
        
        view.bringSubview(toFront: actionButtonViewBack)
        view.bringSubview(toFront: actionButtonView0)
        view.bringSubview(toFront: actionButtonView1)
        view.bringSubview(toFront: actionButtonView2)
        
        
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 20,height: 1000))
        label.font = UIFont(name: "Roboto", size: 15)
        label.textColor = UIColor.lightGray
        label.text = detailObject.getHeaderTitle()
        return label
        
        
    }

    
    
    open func clicked() {
        if delegate != nil {
            let response = delegate.favorite(detailObject.getObjectID()!)
            setColor(response)
        }
    }
    
    open func back() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    open func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailObject.getRelatedDetailsCount()
    }
    
    
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    open func fetchUrl() -> String? {
        //todo
        return ""
    }
    
    open func twitter() {
    }
    
    open func tryToRate() {
    }
    
   
    
    
    
    
}
