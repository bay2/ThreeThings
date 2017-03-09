//
//  WeChatActivity.swift
//  China
//
//  Created by NIX on 15/9/13.
//  Copyright © 2015年 nixWork. All rights reserved.
//

import MonkeyKing

class WeChatActivity: AnyActivity {

    enum `Type` {

        case session
        case timeline

        var activityType: UIActivityType {
            switch self {
            case .session:
                return UIActivityType(rawValue: "com.sim.ThreeThings.WeChat.Session")
            case .timeline:
                return UIActivityType(rawValue: "com.sim.ThreeThings.WeChat.Timeline")
            }
        }

        var title: String {
            switch self {
            case .session:
                return "微信"
            case .timeline:
                return "朋友圈"
            }
        }

        var image: UIImage {
            switch self {
            case .session:
                return UIImage(named: "wechat_session")!
            case .timeline:
                return UIImage(named: "wechat_timeline")!
            }
        }
    }

    init(type: Type, message: MonkeyKing.Message, completionHandler: @escaping MonkeyKing.DeliverCompletionHandler) {

        MonkeyKing.registerAccount(.weChat(appID: ShareConfig.WeChat.appID, appKey: ""))

        super.init(
            type: type.activityType,
            title: type.title,
            image: type.image,
            message: message,
            completionHandler: completionHandler
        )
    }
}

