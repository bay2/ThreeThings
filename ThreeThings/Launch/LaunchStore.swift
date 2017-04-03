//
//  LaunchStore.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/17.
//  Copyright (c) 2017年 xuemincai. All rights reserved.
//

import ReX
import RxSwift
import RealmSwift
import UIKit

enum LaunchPageType {
    case input, home
}


class LaunchStore: ReX.StoreType {
    
    class State {
        
        
        let thingsInfo: Variable<Results<ThreeThingsModel>>
        let pageInfo: Variable<ThreeThingsModel?>
        
        var nowDate: Date {
            didSet  {
                pageInfo.value = thingsInfo.value.filter("writeDate == %@", nowDate.toString(format: "yyyy-MM-dd")).first
            }
        }

        
        init() {
            
            nowDate = Date()
            let realm = try! Realm()
            thingsInfo = Variable<Results<ThreeThingsModel>>(realm.objects(ThreeThingsModel.self))
            pageInfo = Variable<ThreeThingsModel?>(thingsInfo.value.filter("writeDate == %@", nowDate.toString(format: "yyyy-MM-dd")).first)
            
        }
        
    }
    
    let state = State()

}


extension ReX.Getter where Store : LaunchStore {
    
    var lauchPage: Observable<UIViewController?> {
        
        return store.state.thingsInfo.asObservable()
            .flatMap { [unowned store = self.store] _ in store.state.pageInfo.asObservable() }
            .map { (model) -> UIViewController? in
                
                if model?.isFinish == true  {
                    return R.storyboard.home.homeViewController()
                }
            
                return R.storyboard.input.inputViewController()
            
            }
        
        
    }
    
}

extension ReX.Mutation where Store: LaunchStore {
    
    
}

extension ReX.Action where Store: LaunchStore {
    
    
    
}
