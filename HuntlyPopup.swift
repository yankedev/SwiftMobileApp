
//
//  HuntlyPopup.swift
//  My_Devoxx
//
//  Created by Maxime on 03/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation
import UIKit

class HuntlyPopup : UIViewController {

    @IBOutlet var titleBonus: UILabel!
 
    @IBOutlet var pointLbl: UILabel!
    @IBOutlet var pointValueLbl: UILabel!
    @IBOutlet var playMoreBtn: UIButton!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var prizeView: UIView!
    @IBOutlet var promoLabel: UILabel!
    
    override func viewDidLoad() {
        okBtn.addTarget(self, action: #selector(self.okBtnSelector), for: .touchUpInside)
        playMoreBtn.addTarget(self, action: #selector(self.playMoreBtnSelector), for: .touchUpInside)
        
        okBtn.setTitle("OK", for: UIControlState())
        playMoreBtn.setTitle("Play more", for: UIControlState())
        titleBonus.text = ""
        pointLbl.text = ""
        pointValueLbl.text = ""
        promoLabel.text = "Play more & win Devoxx tickets"
        pointLbl.textColor = ColorManager.huntlyOrangeColor
        pointValueLbl.textColor = ColorManager.huntlyOrangeColor
        prizeView.backgroundColor = ColorManager.huntlyOrangeColor
    }
    
    func okBtnSelector() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func playMoreBtnSelector() {
        self.dismiss(animated: true, completion: {
            HuntlyManagerService.sharedInstance.goDeepLink()
            }
        )
    }

}
