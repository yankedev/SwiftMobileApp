//
//  SwitchableProtocol.swift
//  devoxxApp
//
//  Created by maxday on 02.01.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation


public protocol SwitchableProtocol : NSObjectProtocol {
    func updateSwitch(switchValue : Bool)
    func performSwitch()
}