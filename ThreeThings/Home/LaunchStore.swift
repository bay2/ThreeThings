//
//  LaunchStore.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/17.
//  Copyright (c) 2017年 xuemincai. All rights reserved.
//

import ReX
import RxSwift
import UIKit
import CoreData
import Datez

enum LaunchPageType {
    case input, home
}

class LaunchStore: ReX.StoreType {
    
    class State {
        
        lazy var pageInfo: Variable<ThreeThings?> = {
            
            let model = ThreeThings.fetchTodayData()
            return Variable(model)
                        
        }()
        
    }
    
    let state = State()

}

extension ReX.Getter where Store: LaunchStore {
    
    var lauchPage: Observable<UIViewController?> {
        return store.state.pageInfo.asObservable()
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
