//
//  SynciCluodSpec.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/21.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Quick
import Nimble
@testable import ThreeThingsBeta

class SynciCluodSpec: QuickSpec {

    override func spec() {
        
        
        
        describe("Sync File To iCloud") {
            
            class SyncTest: SyncFileToiCloud {
                
                var fileName: String {
                    return "default.realm"
                }
                
                var ubiquitContainerIdentifier: String {
                    return "iCloud.com.simcai.ThreeThings.beta"
                }
                
                var query: NSMetadataQuery = NSMetadataQuery()
                
            }
            
            it("Sync file") {
                
                let s = SyncTest()
                
                try! FileManager.default.removeItem(at: s.getContainerUrl()!)
                
                var result: SyncResult = .saveFailure
                
                s.sync(targetFile: realm.configuration.fileURL!) {
                    result = $0
                    
                }
                
                expect(result).toEventually(equal(SyncResult.success), timeout: 10)
                
            }
            
            it("Query file") {
                
                let s = SyncTest()
                var fileUrl: URL? = nil
                s.queryFile {
                    fileUrl = $0
                }
                
                expect(fileUrl).toEventually(equal(s.getContainerUrl()), timeout: 10)
                
            }
            
            it("Downloading File") {
                
                let s = SyncTest()
                var isDone: SyncResult = .denied
                s.downloadingFile {
                    isDone = $0
                }
                
                expect(isDone).toEventually(equal(SyncResult.success), timeout: 10)
                
            }
            
            
        }        
        
        describe("No permissions") {
            
            class SyncTest: SyncFileToiCloud {
                
                var fileName: String {
                    return "default.realm"
                }
                
                var ubiquitContainerIdentifier: String {
                    return "iCloud.com.simcai.ThreeThings.beta"
                }
                
                var query: NSMetadataQuery = NSMetadataQuery()
                
                func getContainerUrl() -> URL? {
                    return nil
                }
                
            }
            
            it("sync file") {
                
                let s = SyncTest()
                
                var result: SyncResult = .saveFailure
                
                s.sync(targetFile: realm.configuration.fileURL!) {
                    result = $0
                }
                
                expect(result).toEventually(equal(SyncResult.denied), timeout: 10)
                
            }
            
        }
        
        
    }
    
    
}
