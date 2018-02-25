//
//  SpeakerDetailsController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-02-27.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import CoreData

open class SpeakerDetailsController : AbstractDetailsController, UITableViewDelegate, UITableViewDataSource, HotReloadProtocol, FavoritableProtocol {
    

    var talkList = SpeakerListView(frame: CGRect.zero, style: .grouped)
    
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        view.addSubview(talkList)
        
        //talkList.backgroundColor = UIColor.redColor()
        talkList.delegate = self
        talkList.dataSource = self
        
        
        
        
        
        let views = ["header": header, "scroll" : scroll, "talkList" : talkList] as [String : Any]
        
        
        let constH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[header]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[scroll]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        let constH3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[talkList]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        
        
        
        let constV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[header(150)]-[scroll]-[talkList(200)]-0-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        
        
        
        
        
        
        view.addConstraints(constH)
        view.addConstraints(constH2)
        view.addConstraints(constH3)
        
        
        view.addConstraints(constV)
        
        
        
        header.talkTitle.text = detailObject.getTitleD()
        header.talkTrack.text = detailObject.getSubTitle()
        scroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        scroll.text = detailObject.getSummary()
        //scroll.backgroundColor = UIColor.yellowColor()
        
        
        configure()
        
        actionButtonView2.isHidden = true
        
        TalkService.sharedInstance.fetchTalks(detailObject.getRelatedIds(), completionHandler: callBack)
    }
    
    
    
    func callBack(_ talks : [DataHelperProtocol], error : TalksStoreError?) {
        detailObject.setRelated(talks)
        talkList.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    open override func twitter() {
        
        let originalString = detailObject.getTwitter()
     
        
        let escapedString = originalString?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let url = "https://twitter.com/intent/tweet?text=\(escapedString!)"
        
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    
    
    //DATASOUTCE
    
    
    
    
   
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL_10") as? ScheduleCellView
        
        if cell == nil {
            cell = ScheduleCellView(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL_10")
            
        }
        
        
        if let relatedObject = detailObject.getRelatedDetailWithIndex(indexPath.row) {
            
            
        
            cell!.leftIconView.imageView.image = relatedObject.getPrimaryImage()
            
            cell!.rightTextView.topTitleView.talkTrackName.text = "\(relatedObject.getDetailInfoWithIndex(4)?.capitalized ?? "") - \(relatedObject.getDetailInfoWithIndex(2) ?? "")"
            cell!.rightTextView.topTitleView.talkTitle.text = relatedObject.getTitleD()
            
            cell!.rightTextView.locationView.label.text = relatedObject.getDetailInfoWithIndex(0)
            cell!.rightTextView.speakerView.label.text = relatedObject.getDetailInfoWithIndex(3)
            
            
            
            if let fav = relatedObject as? FavoriteProtocol {
                cell!.updateBackgroundColor(fav.isFav())
            }
            
        }
        
        
        
        
        
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
  
    open func favorite(_ id : NSManagedObjectID) -> Bool {
        return SpeakerService.sharedInstance.invertFavorite(id)
    }
    
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let talk = detailObject.getRelatedDetailWithIndex(indexPath.row) {
            
            let details = TalkDetailsController()
            details.delegate = self
            details.detailObject = talk
            
            details.configure()
            
            details.setColor(talk.isFavorited())
        
            
            self.navigationController?.pushViewController(details, animated: true)
        }
        
    }
    
    
    
    func callBackTalks(_ talks : [DataHelperProtocol], error : TalksStoreError?) {
        detailObject.setRelated(talks)
        talkList.reloadData()
    }
    


    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUpdate()
        talkList.reloadData()
    }
    

    open func fetchUpdate() {
        APIReloadManager.fetchUpdate(detailObject.getFullLink(), service: SpeakerDetailService.sharedInstance, completedAction: fetchCompleted)
        
        APIReloadManager.fetchImg(detailObject.getImageFullLink(), id : detailObject.getObjectID(), service:SpeakerService.sharedInstance, completedAction: callbackImg)
    }
   
    open func fetchCompleted(_ newHelper : CallbackProtocol) -> Void {
    
        
        if let newDetailObject = newHelper.getHelper() as? DetailableProtocol {
            detailObject = newDetailObject
        }
        scroll.text = detailObject.getSummary()
        header.talkTrack.text = detailObject.getSubTitle()
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            TalkService.sharedInstance.fetchTalks(self.detailObject.getRelatedIds(), completionHandler:self.callBackTalks)
        })
   }
    
    open func callbackImg(_ newHelper : CallbackProtocol) {
        if let newDetailObjectData = newHelper.getImg() {
            header.imageView.image = UIImage(data: newDetailObjectData as Data)
        }
    }
    
   
    
    
    
    
}
