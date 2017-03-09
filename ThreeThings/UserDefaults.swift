//
//  UserDefaults.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/8.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation

// MARK: - Key Namespaceable

protocol KeyNamespaceable { }

extension KeyNamespaceable {
    private static func namespace(_ key: String) -> String {
        return "\(Self.self).\(key)"
    }
    
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String {
        return namespace(key.rawValue)
    }
}


// MARK: - Bool Defaults
protocol BoolUserDefaultable : KeyNamespaceable {
    associatedtype BoolDefaultKey : RawRepresentable
}

extension BoolUserDefaultable where BoolDefaultKey.RawValue == String {
    
    // Set
    static func set(_ bool: Bool, forKey key: BoolDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(bool, forKey: key)
    }
    
    // Get
    static func bool(forKey key: BoolDefaultKey) -> Bool {
        let key = namespace(key)
        return UserDefaults.standard.bool(forKey: key)
    }
}



extension UserDefaults {
    struct Setting: BoolUserDefaultable {
        enum BoolDefaultKey: String {
            case enableTouchID
        }
    }
}
