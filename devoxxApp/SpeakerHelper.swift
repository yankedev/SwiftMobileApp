//
//  SpeakerHelper.swift
//  devoxxApp
//
//  Created by got2bex on 2015-12-14.
//  Copyright © 2015 maximedavid. All rights reserved.
//

import Foundation
import CoreData

class SpeakerHelper: DataHelperProtocol {
    
    var uuid: String?
    var lastName: String?
    var firstName: String?
    var avatarUrl: String?
    
   /* override var description: String {
        return "uuid: \(uuid)\n lastName: \(lastName)\n firstName: \(firstName)\n avatarUrl: \(avatarUrl)\n"
    }*/
    
    init(uuid: String?, lastName: String?, firstName: String?, avatarUrl: String?) {
        self.uuid = uuid ?? ""
        self.lastName = lastName ?? ""
        self.firstName = firstName ?? ""
        self.avatarUrl = avatarUrl ?? ""
    }
    
    func feed(data: JSON) {
        uuid = data["uuid"].string
        lastName = data["lastName"].string
        firstName = data["firstName"].string
        avatarUrl = data["avatarUrl"].string
    }
    
    func typeName() -> String {
        return entityName()
    }
    
    func entityName() -> String {
        return "Speaker"
    }
    
    func prepareArray(json : JSON) -> [JSON]? {
        return json.array
    }
    
    func save(managedContext : NSManagedObjectContext) {
    }
    
    func save2() -> NSManagedObject? {
        return nil
    }
    
    required init() {
    }
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init()
    }
    
    /*func save(dataHelper : DataHelper) -> Void {
        super.save(dataHelper)
    }
    */
}