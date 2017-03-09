//
//  SettingItem.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/7.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import RxDataSources

enum SettingItem {
    case SwitchItem(title: String, isOn: Bool, setValue: (Bool) -> Void)
}

enum SettingSection {
    case SwitchSection(items: [SettingItem])
}

extension SettingSection: SectionModelType {
    
    typealias Item = SettingItem
    
    var items: [SettingItem] {
        switch self {
        case .SwitchSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: SettingSection, items: [SettingSection.Item]) {
        switch original {
        case .SwitchSection(items: _):
            self = .SwitchSection(items: items)
        }
    }
    
}
