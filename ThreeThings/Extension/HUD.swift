//
//  HUD.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/26.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import MBProgressHUD

class HUD {
    
    private init() { }
    
    static func showMessage(_ message: String?, for view: UIView? = UIApplication.shared.keyWindow) {
        
        guard let message = message, let view = view else { return }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        hud.margin = 10
        hud.offset.y = 150
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        
        hud.hide(animated: true, afterDelay: 1.5)
        
    }
    
    static func showLoading(_ isLoading: Bool, for view: UIView? = UIApplication.shared.keyWindow) {
        
        guard let view = view else { return }
        
        let hudTag = 19786
        if isLoading {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .indeterminate
            hud.tag = hudTag
        } else {
            (view.viewWithTag(hudTag) as? MBProgressHUD)?.hide(animated: true)
        }
    }
    
}
