//
//  RateView.swift
//  devoxxApp
//
//  Created by maxday on 07.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit



class RateView : UITableViewCell, UITextViewDelegate {
    
    
    let label = UILabel()
    let textView = UITextView()
    var key : String?
    
    var delegate : RatingDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(label)
        addSubview(textView)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["label": label, "textView" : textView]
        
        
        let constH0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[label(150)]-10-[textView]-0-|", options: .AlignAllBaseline, metrics: nil, views: views)
        
        let constV0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        let constV1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-5-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        addConstraints(constH0)
        addConstraints(constV0)
        addConstraints(constV1)
        
        
        label.font = UIFont(name: "Roboto", size: 15)
        label.textAlignment = .Right
        label.textColor = ColorManager.grayImageColor
        textView.font = UIFont(name: "Roboto", size: 17)
        
        textView.delegate = self
        
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Type here..." {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type here..."
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(textView: UITextView) {
        delegate?.updateReview(key, review: textView.text)
    }
    
    
    func updateBackgroundColor(isFavorited : Bool) {
        if(isFavorited) {
            backgroundColor = ColorManager.favoriteBackgroundColor
        }
        else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
        
        
        
    }
    
    
    
    
}
