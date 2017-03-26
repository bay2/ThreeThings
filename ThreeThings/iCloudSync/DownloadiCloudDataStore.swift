//
//  DownloadiCloudDataStore.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/25.
//  Copyright (c) 2017年 xuemincai. All rights reserved.
//

import ReX
import RxSwift
import Foundation

enum DownloadState {
    case unknown
    case denied
    case fileNotExist
    case downloading
    case done
}


class DownloadiCloudDataStore: ReX.StoreType {
    

    class State: SyncFileToiCloud {
        
        var fileName: String {
            return Constant.realmFileName
        }
        
        var ubiquitContainerIdentifier: String {
            return Constant.iCloudContainerId
        }
        
        var query: NSMetadataQuery = NSMetadataQuery()
        
        let downloadState: Variable<DownloadState> = Variable(.unknown)
        
    }
    
    let state = State()
    

}

extension ReX.Getter where Store: DownloadiCloudDataStore {
    
    var downloadState: Observable<DownloadState> {
        return store.state.downloadState.asObservable()
    }

}

extension ReX.Mutation where Store: DownloadiCloudDataStore {
    
    var download: Observable<DownloadState> {
        
        return Observable.create { [unowned store = self.store] observer  in
            
            store.state.downloadState.value = .downloading
            observer.onNext(store.state.downloadState.value)
            
            let sendNextAndCompleted: () -> () = {
                observer.onNext(store.state.downloadState.value)
                observer.onCompleted()
            }
            
            store.state.downloadingFile {
                switch $0 {
                case .denied:
                    store.state.downloadState.value = .denied
                    sendNextAndCompleted()
                    
                case .fileNotExist:
                    store.state.downloadState.value = .fileNotExist
                    sendNextAndCompleted()
                    
                case .success:
                    store.state.downloadState.value = .done
                    sendNextAndCompleted()
                    
                default:
                    observer.onCompleted()
                }
            }
            
            
            return Disposables.create {
            }
        }
        
    }
    

}

extension ReX.Action where Store: DownloadiCloudDataStore {


}
