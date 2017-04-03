//
//  LaunchStoreSpec.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/24.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
import RxSwift
import RxCocoa
@testable import ThreeThingsBeta

func setDefaultRealmForUser(username: String) {
    
    let config = Realm.Configuration(
        // Get the URL to the bundled file
        fileURL: Bundle.main.url(forResource: username, withExtension: "realm"),
        // Open the file in read-only mode as application bundles are not writeable
        readOnly: true)
    
    // Set this as the configuration used for the default Realm
    Realm.Configuration.defaultConfiguration  = config
    
    realm = try! Realm()
    
    
}



extension LaunchStore {
    
    convenience init(date: Date) {
        self.init()
        self.state.nowDate = date
    }
    
}


class LaunchStoreSpec: QuickSpec {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func spec() {
        
        setDefaultRealmForUser(username: "OneData")
        
 
        describe("Launch Page Test") {
            
            it("On the day of the unfinished") {
                
                setDefaultRealmForUser(username: "UnfinishedData")
                
                let launchStore = LaunchStore()
                
                launchStore.getter.lauchPage.bindNext { (vc) in
                    expect(vc?.className).to(equal(R.storyboard.input.inputViewController()?.className))
                    }
                    .addDisposableTo(self.disposeBag)
                
                
            }
            
            
            
            it("On the day of the complete data") {
                
                setDefaultRealmForUser(username: "OneData")
                
                let launchStore = LaunchStore(date: Date(fromString: "2017-03-23", format: "yyyy-MM-dd")!)
                
                launchStore.getter.lauchPage.bindNext { (vc) in
                    expect(vc?.className).to(equal(R.storyboard.home.homeViewController()?.className))
                }
                .addDisposableTo(self.disposeBag)
                
            }
            
            it("No data for that day") {
                
                let launchStore = LaunchStore()
                
                launchStore.getter.lauchPage.bindNext { (vc) in
                    expect(vc?.className).to(equal(R.storyboard.input.inputViewController()?.className))
                }
                .addDisposableTo(self.disposeBag)
                
            }
            
//            
//            it("Data is nil") {
//                
//                setDefaultRealmForUser(username: "NilData")
//                
//                let launchStore = LaunchStore()
//                
//                launchStore.getter.lauchPage.bindNext { (vc) in
//                    expect(vc?.className).to(equal(R.storyboard.iCloud.downloadiCloudDataViewController()?.className))
//                    }
//                    .addDisposableTo(self.disposeBag)
//                
//            }
            

        }
            
        
    }
    
}
