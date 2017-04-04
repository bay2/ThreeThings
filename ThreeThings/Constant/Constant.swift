//
//  Constant.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/24.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation

struct Constant {
    
#if DEBUG
    static let iCloudContainerId = "iCloud.com.simcai.ThreeThings.beta"
#else
    static let iCloudContainerId = "iCluod.com.simcai.ThreeThings"
#endif
    
    static let realmFileName = "default.realm"
    
    static let sendEmail = "mailto:sim_cai@icloud.com"
    
}
