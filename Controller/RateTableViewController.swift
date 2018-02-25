//
//  RateTableViewController.swift
//  devoxxApp
//
//  Created by got2bex on 2016-03-07.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit


protocol RatingDelegate {
    func updateReview(_ key : String?, review : String)
}


open class RateTableViewController : UITableViewController, UIAlertViewDelegate, RatingDelegate {
    
    
    var rateObject : RatableProtocol!
    
    
    var reviewContent = Dictionary<String, String>()
    
    enum KindOfSection : Equatable {
        case talk
        case stars
        case talk_CONTENT_FEEDBACK
    }
    
    enum TalkDescription : Equatable {
        case title
        case speaker
    }
    
    fileprivate struct NavigationButtonString {
        static let vote = NSLocalizedString("Send", comment: "")
    }
    
    fileprivate struct RateLabelString {
        static let selectStars = NSLocalizedString("Select stars", comment: "")
        static let leaveFeedback = NSLocalizedString("Optional feedback", comment: "")
    }
    
    fileprivate struct RateQuestionString {
        static let question0 = NSLocalizedString("Content feedback :", comment: "")
        static let placeHolder0 = NSLocalizedString("Awesome content?", comment: "")
        static let question1 = NSLocalizedString("Delivery remarks :", comment: "")
        static let placeHolder1 = NSLocalizedString("Presentation skills?", comment: "")
        static let question2 = NSLocalizedString("Other :", comment: "")
        static let placeHolder2 = NSLocalizedString("Compliments or ?", comment: "")
    }
    
    fileprivate struct VoteSuccessAlertString {
        static let title = NSLocalizedString("Thanks !", comment: "")
        static let content = NSLocalizedString("Thank you for your awesome vote", comment: "")
        static let okButton = NSLocalizedString("Ok", comment: "")
    }
    
    fileprivate struct VoteFailAlertString {
        static let title = NSLocalizedString("Ouuups !", comment: "")
        static let content = NSLocalizedString("Something went wrong ... please retry", comment: "")
        static let okButton = NSLocalizedString("Ok", comment: "")
    }
    
    override open func viewDidLoad() {
        self.view.backgroundColor = UIColor.lightGray
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        self.title = "Rate this talk"
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(RateTableViewController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavigationButtonString.vote, style: .plain, target: self, action: #selector(RateTableViewController.vote))
        
        tableView.separatorStyle = .none
        
    }
    
    
    open func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func createDetails(_ nbStar : Int, aspectTitle : String?, reviewContent : String?) {
    
        
        
        
    }
    
    fileprivate func createDetailObject(_ rating : Int, key : String) -> JSON {
        let review:String = reviewContent[key]!
        return JSON(["aspect" : key, "rating" : rating, "review" : review])
    }
    
    open func vote() {
        
        
        let nbStar = tableView.cellForRow(at: IndexPath(row: 0, section: KindOfSection.stars.hashValue)) as? StarView

        var tab = [JSON]()
        
        if nbStar != nil {
            for key in reviewContent {
                if !key.1.isEmpty {
                    tab.append(createDetailObject(nbStar!.getSelectedStars(), key: key.0))
                }
            }
        }
        
        var json:JSON = [:]
        if tab.count > 0 {
            json["details"] = JSON(tab)
        }
        else {
            json["rating"] = JSON(nbStar!.getSelectedStars())
        }
        json["talkId"] = JSON(rateObject.getIdentifier())
        json["user"] = JSON(APIManager.getQrCode()!)
        
    
        let request = NSMutableURLRequest(url: URL(string: "https://cfp-vdt.exteso.com/api/voting/v1/vote")!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
      
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: json.object, options: [])
        
        /*
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard data != nil else {
                self.alertFailure()
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    self.alertSucess()
                }
                else if httpResponse.statusCode == 202 {
                    DispatchQueue.main.async(execute: {
                        
                        let alert = UIAlertController(title: VoteSuccessAlertString.title, message: VoteSuccessAlertString.content, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: VoteSuccessAlertString.okButton, style: UIAlertActionStyle.default, handler: nil))
                        
                        self.parent?.present(alert, animated: true, completion:  nil)
                        
                    })
                }
                else {
                    self.alertFailure()
                    return
                }
            }
            
        }) 
        
        task.resume()
        */
    }
    
    func alertSucess() {
        DispatchQueue.main.async(execute: {
            
            let alert = UIAlertController(title: VoteSuccessAlertString.title, message: VoteSuccessAlertString.content, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: VoteSuccessAlertString.okButton, style: UIAlertActionStyle.default, handler: self.dissmiss))
            
            self.parent?.present(alert, animated: true, completion:  nil)
            
        })
    }

    func alertFailure() {
        DispatchQueue.main.async(execute: {
            
            let alert = UIAlertController(title: VoteFailAlertString.title, message: VoteFailAlertString.content, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: VoteFailAlertString.okButton, style: UIAlertActionStyle.default, handler: nil))
            
            self.parent?.present(alert, animated: true, completion:  nil)
            
        })
    }

    /*
    func feedEventId() {
        HuntlyManagerService.sharedInstance.feedEventId(prepareHuntly, callbackFailure : dismiss)
    }
    
    
    func prepareHuntly() {
        HuntlyManagerService.sharedInstance.storeToken("vote", handlerSuccess: hunltyManager, handlerFailure : dismiss)
    }
    
    
    func hunltyManager() {
        print(UIStoryboard(name: "Huntly", bundle: nil).instantiateViewController(withIdentifier: "HuntlyPopup") as? HuntlyPopup)
        if let viewController = UIStoryboard(name: "Huntly", bundle: nil).instantiateViewController(withIdentifier: "HuntlyPopup") as? HuntlyPopup {
            
            self.navigationController?.present(viewController, animated: true, completion: {
                viewController.titleBonus.text = "You just won"
                viewController.pointLbl.text = "Points"
                viewController.pointValueLbl.text = "+\(HuntlyManagerService.sharedInstance.VOTE_QUEST_POINTS)"
                
                viewController.okBtn.addTarget(self, action: #selector(RateTableViewController.dismiss), for: .touchUpInside)

            })
 
        }
        else {
            dismiss()
        }
        
    }
 */
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    func dissmiss(_ action : UIAlertAction) {
        //feedEventId()
    }
    
    
    
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == KindOfSection.talk.hashValue) {
            return ""
        }
        if(section == KindOfSection.stars.hashValue) {
            return RateLabelString.selectStars
        }
        if(section == KindOfSection.talk_CONTENT_FEEDBACK.hashValue) {
            return RateLabelString.leaveFeedback
        }
        return ""
    }
    
    
    
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == KindOfSection.talk.hashValue) {
            return 2
        }
        if(section == KindOfSection.stars.hashValue) {
            return 1
        }
        if(section == KindOfSection.talk_CONTENT_FEEDBACK.hashValue) {
            return 3
        }
        return 0
    }
    
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        
        
        if indexPath.section == KindOfSection.talk.hashValue  {
            if indexPath.row == TalkDescription.title.hashValue {
                var cell = tableView.dequeueReusableCell(withIdentifier: "TALK_TITLE")
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "TALK_TITLE")
                }
                cell?.textLabel?.font = UIFont(name: "Roboto", size: 17)
                cell?.textLabel?.text = rateObject.getTitle()
                cell?.textLabel?.numberOfLines = 0
                return cell!
            }
            else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "TALK_SPEAKER")
                if cell == nil {
                    cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "TALK_SPEAKER")
                }
                cell?.textLabel?.font = UIFont(name: "Roboto", size: 13)
                cell?.textLabel?.textColor = ColorManager.grayImageColor
                cell?.textLabel?.text = rateObject.getSubTitle()
                cell?.textLabel?.numberOfLines = 0
                return cell!
            }
        }
            
            
        else if indexPath.section == KindOfSection.stars.hashValue  {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "STAR_CELL")
            
            if cell == nil {
                cell = StarView(style: UITableViewCellStyle.value1, reuseIdentifier: "STAR_CELL")
            }
            
            
            
            return cell!
            
        }
            
        else  {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "FEEDBACK_CELL") as? RateView
            
            if cell == nil {
                cell = RateView(style: UITableViewCellStyle.value1, reuseIdentifier: "FEEDBACK_CELL")
            }
            
            if indexPath.row == 0 {
                cell?.label.text = RateQuestionString.question0
                cell?.key = "Content"
                cell?.review.placeholder = RateQuestionString.placeHolder0
            }
            if indexPath.row == 1 {
                cell?.label.text = RateQuestionString.question1
                cell?.key = "Delivery"
                cell?.review.placeholder = RateQuestionString.placeHolder1
            }
            if indexPath.row == 2 {
                cell?.label.text = RateQuestionString.question2
                cell?.key = "Other"
                cell?.review.placeholder = RateQuestionString.placeHolder2
            }
            
            cell?.delegate = self
            
            return cell!
            
        }
        
    }
    
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == KindOfSection.stars.hashValue  {
            return 60
        }
        
        if indexPath.section == KindOfSection.talk.hashValue && indexPath.row == TalkDescription.title.hashValue {
            return 40
        }
        
        if indexPath.section == KindOfSection.talk.hashValue && indexPath.row == TalkDescription.speaker.hashValue {
            return 30
        }
        
        return 70
    }
    
    
    
    func updateReview(_ key : String?, review: String) {
        
        if key != nil {
            reviewContent[key!] = review
        }
        
              
    }
    
    
    
    
    
}
