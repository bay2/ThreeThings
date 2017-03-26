//
//  DownloadiCloudDataStoreSpec.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/25.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import ThreeThingsBeta


class DownloadiCloudDataStoreSpec: QuickSpec {
    
    fileprivate let disposeBag = DisposeBag()
    
    override func spec() {
        
        describe("Download file") {
            
            it("Download file does not exist ") {
                
                let store = DownloadiCloudDataStore()
                
                if FileManager.default.isUbiquitousItem(at: store.state.getContainerUrl()!) {
                    try! FileManager.default.removeItem(at: store.state.getContainerUrl()!)
                }
                
                var state1 = DownloadState.unknown
                var state2 = DownloadState.unknown
                
                store.commit.download.bindNext {
                    state1 = $0
                }
                .addDisposableTo(self.disposeBag)
                
                store.getter.downloadState.bindNext {
                    state2 = $0
                }
                .addDisposableTo(self.disposeBag)
                
                expect(state1).toEventually(equal(DownloadState.fileNotExist), timeout: 3)
                expect(state2).toEventually(equal(DownloadState.fileNotExist), timeout: 3)
                
            }
            
            it("Download file success") {
                
                let store = DownloadiCloudDataStore()
                                
                var state1 = DownloadState.unknown
                var state2 = DownloadState.unknown
                
                var result: SyncResult = .saveFailure
                
                store.state.sync(targetFile: realm.configuration.fileURL!) {
                    result = $0
                    
                }
                
                expect(result).toEventually(equal(SyncResult.success), timeout: 10)
                
                store.commit.download.bindNext {
                    state1 = $0
                }
                .addDisposableTo(self.disposeBag)
                
                store.getter.downloadState.bindNext {
                    state2 = $0
                }
                .addDisposableTo(self.disposeBag)
                
                expect(state1).toEventually(equal(DownloadState.done), timeout: 10)
                expect(state2).toEventually(equal(DownloadState.done), timeout: 10)
                
            }
            
        }

    }
}
