//
//  HomeStore.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/2/18.
//  Copyright (c) 2017年 xuemincai. All rights reserved.
//

import RxSwift
import RealmSwift
import ReX
import Foundation

extension Array where Element : RealmSwift.Object {
    init(_ results: Results<Element>) {
        
        self = [Element]()
        
        for result in results {
            self.append(result)
        }
        
    }
}

class HomeStore: ReX.StoreType {
    
    class State {
        
        let selectDate = Variable<Date>(Date())
        let thingsList = Variable<Results<ThreeThingsModel>>(realm.objects(ThreeThingsModel.self).filter("isFinish == %@", true))
    
    }
    
    let state = State()

}

extension ReX.Getter where Store: HomeStore {
    
    var thingsList: Observable<[ThingItem]>  {
        return store.state.selectDate.asObservable()
            .map { [unowned store = self.store] date in
                store.state.thingsList.value.filter("writeDate == %@", date.toString(format: "yyyy-MM-dd")).first
            }
            .map { (model) -> [ThingItem] in
                guard let model = model else {
                    return []
                }
                
                return [ThingItem(model.writeDate + "#1", thing: model.firstThing),
                        ThingItem(model.writeDate + "#2", thing: model.secondThing),
                        ThingItem(model.writeDate + "#3", thing: model.threeThing)]
            }
    }
    
    var thingsDateList: Observable<[Date]> {
        return store.state.thingsList.asObservable().map { results in
            return Array(results).map { model in
                Date(fromString: model.writeDate, format: "yyyy-MM-dd")!
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
