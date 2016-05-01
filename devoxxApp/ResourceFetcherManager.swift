//
//  ResourceFetcherManager.swift
//  My_Devoxx
//
//  Created by Maxime on 12/03/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import Foundation

class ResourceFetcherManager {
    
    static var map = Dictionary<String, NSDate>()
    
    class func isAllowedToFetch(url : String?) -> Bool {
        
        if url == nil {
            return false
        }
        
        if NSURL(string: url!) == nil {
            return false
        }
        if map[url!] == nil {
            map[url!] = NSDate()
            return true
        }
        
        if abs(map[url!]!.timeIntervalSinceNow) > 1 {
            map[url!] = NSDate()
            return true
        }
        
        return false
    }
    
    
    
    
}