//
//  ThingItem.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/18.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import RxDataSources

struct ThingItem {
    let id: String
    let thing: String
    
    init(_ id: String, thing: String) {
        self.id = id
        self.thing = thing
    }
    
}

extension ThingItem: IdentifiableType, Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
    var identity: String {
        return id
    }
    
    static func == (lhs: ThingItem, rhs: ThingItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
