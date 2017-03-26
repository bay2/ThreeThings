//
//  ThreeThingsModel.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/1/31.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import EZSwiftExtensions

class ThreeThingsModel: Object {
    
    dynamic var firstThing = ""
    dynamic var secondThing = ""
    dynamic var threeThing = ""
    dynamic var writeDate = Date().toString(format: "yyyy-MM-dd")
    dynamic var isFinish = false
    
    override static func primaryKey() -> String? {
        return "writeDate"
    }
    

}
