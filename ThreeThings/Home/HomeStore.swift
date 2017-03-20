//
//  HomeStore.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/18.
//  Copyright (c) 2017年 xuemincai. All rights reserved.
//

import RxSwift
import ReX
import Foundation
import Datez


class HomeStore: ReX.StoreType {
    
    class State {
        
        let selectDate = Variable<Date>(Date())
        let thingsList = Variable(ThreeThings.fetchFinishData())
    
    }
    
    let state = State()

}

extension ReX.Getter where Store: HomeStore {
    
    var thingsList: Observable<[ThingItem]>  {
        return store.state.selectDate.asObservable()
            .map { [unowned store = self.store] date in
                return store.state.thingsList.value.filter { (things) -> Bool in
                    let date = things.writeDate as! Date
                    return date.isToday
                }
                .first
            }
            .map { (model) -> [ThingItem] in
                guard let model = model else {
                    return []
                }
                
                let dateString = (model.writeDate as! Date).toString(format: "yyyy-MM-dd")
                
                return [ThingItem(dateString + "#1", thing: model.firstThing ?? ""),
                        ThingItem(dateString + "#2", thing: model.secondThing ?? ""),
                        ThingItem(dateString + "#3", thing: model.threeThing ?? "")]
            }
    }
    
    var thingsDateList: Observable<[Date]> {
        return store.state.thingsList.asObservable().map { results in
            return Array(results).map { model in
                model.writeDate as! Date
            }
        }
    }
    
}

extension ReX.Mutation where Store: HomeStore {
    
    var fetch: (_ date: Date) -> Void {
        
        return { [unowned store = self.store] date in
            store.state.selectDate.value = date
        }
        
    }
    

}

extension ReX.Action where Store: HomeStore {

    var fetch: (_ date: Date) -> Observable<Void> {
        
        return { [unowned store = self.store] date in
            
            store.commit.fetch(date)
            
            return Observable.empty()
            
        }
        
    }

}
