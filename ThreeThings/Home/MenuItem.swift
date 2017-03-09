//
//  MenuItem.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/6.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import RxDataSources

enum MenuItem {

    case TitleSectionItem(title: String, click: () -> Void)
}

enum MenuSection {
    case TitleSection(items: [MenuItem])
}

extension MenuSection: SectionModelType {
    
    typealias Item = MenuItem
    
    init(original: MenuSection, items: [MenuSection.Item]) {
        switch original {
        case .TitleSection(items: _):
            self = .TitleSection(items: items)
        }
    }
    
    var items: [MenuItem] {
        switch self {
        case .TitleSection(items: let items):
            return items.map { $0 }
        }
    }

    
}
