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
    func updateReview(key : String?, review : String)
}


public class RateTableViewController : UITableViewController, UIAlertViewDelegate, RatingDelegate {
    
    
    var rateObject : RatableProtocol!
    
    
    var reviewContent = Dictionary<String, String>()
    
    enum KindOfSection : Equatable {
        case TALK
        case STARS
        case TALK_CONTENT_FEEDBACK
    }
    
    private struct NavigationButtonString {
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let vote = NSLocalizedString("Vote", comment: "")
    }
    
    private struct RateLabelString {
        static let selectStars = NSLocalizedString("Select stars", comment: "")
        static let leaveFeedback = NSLocalizedString("Leave a feedback (optional)", comment: "")
    }
    
    private struct RateQuestionString {
        static let question0 = NSLocalizedString("Content feedback :", comment: "")
        static let question1 = NSLocalizedString("Delivery remarks :", comment: "")
        static let question2 = NSLocalizedString("Other :", comment: "")
        static let defaultResponse = NSLocalizedString("Type here...", comment: "")
        
    }
    
    override public func viewDidLoad() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NavigationButtonString.cancel, style: .Plain, target: self, action: Selector("cancel"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavigationButtonString.vote, style: .Plain, target: self, action: Selector("vote"))
        
    }
    
    
    public func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func createDetails(nbStar : Int, aspectTitle : String?, reviewContent : String?) {
    
        
        
        
    }
    
    private func createDetailObject(rating : Int, key : String) -> JSON {
        let review:String = reviewContent[key]!
        return JSON(["aspect" : key, "rating" : rating, "review" : review])
    }
    
    public func vote() {
        
        
        let nbStar = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: KindOfSection.STARS.hashValue)) as? StarView
        
        
  
        
        var tab = [JSON]()
        
        if nbStar != nil {
            for key in reviewContent {
                tab.append(createDetailObject(nbStar!.getSelectedStars(), key: key.0))
            }
        }
        
        var json:JSON = [:]
        json["details"] = JSON(tab)
        json["rating"] = JSON(nbStar!.getSelectedStars())
        json["talkId"] = JSON(rateObject.getIdentifier())
        json["user"] = JSON(12345)
        
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api-voting.devoxx.com/DevoxxFR2016/vote")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print(json.description)
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(json.object, options: [])
        
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            print(data)
            print(response)
            print(error)
            
            // this, on the other hand, can quite easily fail if there's a server error, so you definitely
            // want to wrap this in `do`-`try`-`catch`:
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    let success = json["success"] as? Int                                  // Okay, the `json` is here, let's get the value for 'success' out of it
                    print("Success: \(success)")
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)    // No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()
        
       
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == KindOfSection.TALK.hashValue) {
            return ""
        }
        if(section == KindOfSection.STARS.hashValue) {
            return RateLabelString.selectStars
        }
        if(section == KindOfSection.TALK_CONTENT_FEEDBACK.hashValue) {
            return RateLabelString.leaveFeedback
        }
        return ""
    }
    
    
    
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == KindOfSection.TALK.hashValue) {
            return 1
        }
        if(section == KindOfSection.STARS.hashValue) {
            return 1
        }
        if(section == KindOfSection.TALK_CONTENT_FEEDBACK.hashValue) {
            return 3
        }
        return 0
    }
    
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        
        
        if indexPath.section == KindOfSection.TALK.hashValue  {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("TALK")
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "TALK")
            }
            
            cell?.textLabel?.text = rateObject.getTitle()
            cell?.textLabel?.numberOfLines = 0
            
            
            return cell!
            
        }
            
            
        else if indexPath.section == KindOfSection.STARS.hashValue  {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("STAR_CELL")
            
            if cell == nil {
                cell = StarView(style: UITableViewCellStyle.Value1, reuseIdentifier: "STAR_CELL")
            }
            
            
            
            return cell!
            
        }
            
        else  {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("FEEDBACK_CELL") as? RateView
            
            if cell == nil {
                cell = RateView(style: UITableViewCellStyle.Value1, reuseIdentifier: "FEEDBACK_CELL")
            }
            
            if indexPath.row == 0 {
                cell!.label.text = RateQuestionString.question0
                cell!.key = "content"
            }
            if indexPath.row == 1 {
                cell!.label.text = RateQuestionString.question1
                cell!.key = "delivery"
            }
            if indexPath.row == 2 {
                cell!.label.text = RateQuestionString.question2
                cell!.key = "other"
            }
            
            
            
            cell!.textView.text = RateQuestionString.defaultResponse
            
            cell!.delegate = self
            
            return cell!
            
        }
        
    }
    
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == KindOfSection.STARS.hashValue  {
            return 60
        }
        
        return 70
    }
    
    
    
    func updateReview(key : String?, review: String) {
        
        if key != nil {
            reviewContent[key!] = review
        }
        
        print(reviewContent)
        
    }
    
    
    
    
    
}
