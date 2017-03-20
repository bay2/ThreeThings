//
//  InputStore.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/1/29.
//  Copyright (c) 2017年 xuemincai. All rights reserved.
//

import ReX
import RxSwift
import RealmSwift
import Foundation
import CoreData

enum InputViewCtrlState {
    case next, last, done, save
}

class InputStore: ReX.StoreType {
    
    class State {
        
        let pageInfo: Variable<ThreeThings>
        let currentPageIndex: Variable<Int>
        
        init(_ index: Int) {
            
            self.currentPageIndex = Variable<Int>(index)
            
            ThreeThings.addTodayData { (threeThings) in
                threeThings.writeDate = NSDate()
            }
            
            self.pageInfo = Variable(ThreeThings.fetchTodayData()!)
            
        }
   
    }
    
    let state: State
    
    init(_ index: Int = 0) {
        self.state = State(index)
    }
    
    

}

extension ReX.Getter where Store: InputStore {
    
    var currentPageIndex: Observable<Int> {
        return store.state.currentPageIndex.asObservable()
    }
    
    var isFirstPage: Observable<Bool> {
        return store.getter.currentPageIndex.map { index in index == 0 ? true : false }
    }
    
    var isLastPage: Observable<Bool> {
        return store.getter.currentPageIndex.map { index in index == 2 ? true : false }
    }
    
    var pageInfo: Observable<String> {
        
        return store.getter.currentPageIndex.map { [unowned store = self.store] index -> String in
            switch index {
            case 0:
                return store.state.pageInfo.value.firstThing ?? ""
            case 1:
                return store.state.pageInfo.value.secondThing ?? ""
            case 2:
                return store.state.pageInfo.value.threeThing ?? ""
            default:
                return ""
            }
        }
        

    }

}

extension ReX.Mutation where Store: InputStore {
    
    var saveIndex: (Int, String) -> (Void)  {
        
        return {  index, description in
            
            ThreeThings.addTodayData { things in
                switch index {
                case 0:
                    things.firstThing = description
                case 1:
                    things.secondThing = description
                case 2:
                    things.threeThing = description
                default:
                    break
                }
            }

        }
    }
    
    var save: (Void) -> (Void)  {
        
        return {
            
            ThreeThings.addTodayData { things in
                things.isFinish = true
            }

        }
    }

}

extension ReX.Action where Store: InputStore {
    
    var next: (String) -> Observable<Int> {
        
        return { [unowned store = self.store]  description in
            
            return store.getter.currentPageIndex.take(1).do(onNext: { index in
                store.commit.saveIndex(index, description)
            })
            .map { _ in
                return store.state.currentPageIndex.value + 1
            }

        }
        
    }
    
    var last: (String) -> Observable<InputViewCtrlState> {
        
        return { [unowned store = self.store]  description in
            
            return store.getter.currentPageIndex.take(1).do(onNext: { index in
                store.commit.saveIndex(index, description)
            })
            .map { _ in
                return InputViewCtrlState.last
            }
            
        }
        
    }
    
    var done: (String) -> Observable<ThreeThings> {
        
        return { [unowned store = self.store]  description in
            
            store.commit.saveIndex(2, description)
            
            return Observable.just(store.state.pageInfo.value)
            
        }
        
    }
    
    var save: (Void) -> Observable<InputViewCtrlState> {
        
        return { [unowned store = self.store] in
            store.commit.save()
            return Observable.just(InputViewCtrlState.save)
        }
        
    }

}
