//
//  CreditsController.swift
//  My_Devoxx
//
//  Created by Maxime on 18/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//


import Foundation
import UIKit


public class CreditsController : AbstractDetailsController {
    
    
    
    private struct CreditString {
        static let title = NSLocalizedString("Credit", comment: "")
        static let content = NSLocalizedString("The following people turned the 'My Devoxx' ambition into a reality:\n\nAndroid app by Jacek Modrakowski (@jacek_beny) from Scalac.io\n\niOS apps by Maxime David (@xouuox)\n\nWindows mobile app by Julian Ronge from ConSol* GmbH (https://www.consol.de)\n\niWatch by Sebastien Arbogast\n\nAndroid Wear by Said Eloudrhiri\n\nDesign by Saad Benameur, Nabil Moursli, Mouad Benhsain, Mohamed ElAsri from Laffere Team (http://www.laffere.ma)\n\nCall For Papers web app by Nicolas Martignole\n\nProject management by Stephan Janssen", comment: "")
    }
    
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()

        
        let views = ["header": header, "scroll" : scroll]
        
        
        let constH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[header]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        let constH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[scroll]-10-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        
        let constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[header(150)]-[scroll]-0-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        view.addConstraints(constH)
        view.addConstraints(constH2)

        view.addConstraints(constV)
        
        
        
        header.talkTitle.text = CreditString.title
        scroll.text = CreditString.content
      
       
        actionButtonView0.hidden = true
        actionButtonView1.hidden = true
        actionButtonView2.hidden = true
        
    }
    
    
    
    
}