//
//  LicenseItem.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/10.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import RxDataSources

enum Frameworks: String {
    case EZSwiftExtensions, MonkeyKing, ReX, Rswift, RxSwift, RxDataSources, RxKeyboard, Realm, FSCalendar, IBAnimatable
}

extension Frameworks {
    
    var licenseURL: String {
        switch self {
        case .EZSwiftExtensions:
            return "https://raw.githubusercontent.com/goktugyil/EZSwiftExtensions/master/LICENSE"
        case .MonkeyKing:
            return "https://raw.githubusercontent.com/nixzhu/MonkeyKing/master/LICENSE"
        case .ReX:
            return "https://raw.githubusercontent.com/ReXSwift/ReX/master/LICENSE"
        case .Rswift:
            return "https://raw.githubusercontent.com/mac-cain13/R.swift.Library/master/License"
        case .RxSwift:
            return "https://raw.githubusercontent.com/ReactiveX/RxSwift/master/LICENSE.md"
        case .RxDataSources:
            return "https://raw.githubusercontent.com/RxSwiftCommunity/RxDataSources/master/LICENSE.md"
        case .RxKeyboard:
            return "https://raw.githubusercontent.com/RxSwiftCommunity/RxKeyboard/master/LICENSE"
        case .Realm:
            return "https://raw.githubusercontent.com/realm/realm-cocoa/master/LICENSE"
        case .FSCalendar:
            return "https://raw.githubusercontent.com/WenchaoD/FSCalendar/master/LICENSE"
        case .IBAnimatable:
            return "https://raw.githubusercontent.com/IBAnimatable/IBAnimatable/master/LICENSE"
            
        }
    }
    
}

extension Frameworks {
    var frameworkName: String {
        
        switch self {
        case .Rswift:
            return "R.swift.Library"
        default:
            return self.rawValue
        }
    }
}


enum LicenseItem {
    case LicenseItem(frameworks: Frameworks)
}

enum LicenseSection {
    case LicenseSection(items: [LicenseItem])
}

extension LicenseSection: SectionModelType {
    
    typealias Item = LicenseItem
    
    var items: [LicenseItem] {
        switch self {
        case .LicenseSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: LicenseSection, items: [LicenseSection.Item]) {
        switch original {
        case .LicenseSection(items: _):
            self = .LicenseSection(items: items)
        }
    }
    
}
