//
//  AppDelegate.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/1/27.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import MonkeyKing
import LocalAuthentication

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("\(realm.configuration)")  
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        
        return false
    }
    

}


//extension UIWindow {
//    
//    /// Fix for http://stackoverflow.com/a/27153956/849645
//    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
//        
//        let previousViewController = rootViewController
//        
//        if let transition = transition {
//            // Add the transition
//            layer.add(transition, forKey: kCATransition)
//        }
//        
//        rootViewController = newRootViewController
//        
//        // Update status bar appearance using the new view controllers appearance - animate if needed
//        if UIView.areAnimationsEnabled {
//            UIView.animate(withDuration: CATransaction.animationDuration()) {
//                newRootViewController.setNeedsStatusBarAppearanceUpdate()
//            }
//        } else {
//            newRootViewController.setNeedsStatusBarAppearanceUpdate()
//        }
//        
//        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
//        if let transitionViewClass = NSClassFromString("UITransitionView") {
//            for subview in subviews where subview.isKind(of: transitionViewClass) {
//                subview.removeFromSuperview()
//            }
//        }
//        if let previousViewController = previousViewController {
//            // Allow the view controller to be deallocated
//            previousViewController.dismiss(animated: false) {
//                // Remove the root view in case its still showing
//                previousViewController.view.removeFromSuperview()
//            }
//        }
//    }
//}

