//
//  State.swift
//  ThoroughbredInsider
//
//  Created by TCCODER on 10/31/17.
//Copyright © 2017 Topcoder. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * state
 *
 * - author: TCCODER
 * - version: 1.0
 */
class State: Object {
    
    /// fields
    @objc dynamic var id = 0
    @objc dynamic var code = ""
    @objc dynamic var name = ""
    
    /// primary key
    override class func primaryKey() -> String? {
        return "id"
    }
}
