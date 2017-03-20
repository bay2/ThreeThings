//
//  AppDelegate.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/1/27.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit
import RxSwift
import MonkeyKing
import LocalAuthentication
import CoreData

let managedContext = DataAccess.sharedInstance.managedObjectContext!


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.simcai.ThreeThings.beta")
        if containerURL != nil {
            print("success:\(containerURL)")
        }
        else{
            print("URL=nil")
        }
                
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        
        return false
    }
    

}

