//
//  Achievement.swift
//  ThoroughbredInsider
//
//  Created by TCCODER on 11/2/17.
//Copyright © 2017 Topcoder. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * achievement / task
 *
 * - author: TCCODER
 * - version: 1.0
 */
class Achievement: Object {
    
    /// fields
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var content = ""
    @objc dynamic var completed = false
    @objc dynamic var isDaily = false
    @objc dynamic var pts = 0
    
    /// primary key
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
