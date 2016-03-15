//
//  HotReloadProtocol.swift
//  devoxxApp
//
//  Created by maxday on 06.03.16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

public protocol HotReloadProtocol {
    
    func fetchUpdate() -> Void
    func fetchCompleted(msg : CallbackProtocol) -> Void
    func fetchUrl() -> String?
    
}


