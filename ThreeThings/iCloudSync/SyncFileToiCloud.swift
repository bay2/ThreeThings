//
//  SyncFileToiCloud.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/24.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit



enum SyncResult {
    case denied //没有权限
    case saveFailure // 保存失败
    case fileNotExist // 文件不存在
    case success // 成功
    
}

protocol GetContainerUrl {
    
    var ubiquitContainerIdentifier: String { get }
    
    var fileName: String { get }
    
    func getContainerUrl() -> URL?
    
}

extension GetContainerUrl {
    
    /// 获取存储到iCloud的文件路径
    ///
    /// - Returns: 文件路径
    func getContainerUrl() -> URL? {
        
        print("\(ubiquitContainerIdentifier)")
        guard let url = FileManager.default.url(forUbiquityContainerIdentifier: ubiquitContainerIdentifier) else {
            return nil
        }
        
        let newUrl = url.appendingPathComponent("Documents/" + fileName)
                
        return newUrl
    }
    
}


protocol SyncFileToiCloud: GetContainerUrl {
    
    
    var fileName: String { get }
    var query: NSMetadataQuery { set get }
    
    
    func sync(targetFile: URL, completionHandler: @escaping (SyncResult) -> ())
    
    func queryFile(completionHandler: @escaping (URL?) -> ())
    
    func downloadingFile(completionHandler: @escaping (SyncResult) -> ())
        
}

extension SyncFileToiCloud {
    
    
    /// 将文件同步到iCloud
    ///
    /// - Parameters:
    ///   - targetFile: 要同步的文件路径
    ///   - completionHandler: 完成回调
    func sync(targetFile: URL, completionHandler: @escaping (SyncResult) -> ()) {
        
        guard let url = getContainerUrl() else {
            completionHandler(.denied)
            return
        }
        
        let manage = ThingsDocument(fileURL: url, targetFile: targetFile)
        
        query.disableUpdates()
        
        let fileManager = FileManager.default
        
        if (fileManager.fileExists(atPath: url.description)) {
            try! fileManager.removeItem(at: url)
        }
        
        manage.open { _ in
            
            manage.save(to: url, for: .forCreating) { (success) in
                if (success) {
                    completionHandler(.success)
                    self.query.enableUpdates()
                } else {
                    completionHandler(.saveFailure)
                    self.query.enableUpdates()
                }
            }
        }
        
    }
    
    
    /// 查询文件路径
    ///
    /// - Parameter completionHandler: 完成回调
    func queryFile(completionHandler: @escaping (URL?) -> ()) {
        
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        
        let center = NotificationCenter.default
        
        
        center.addObserver(forName: .NSMetadataQueryDidFinishGathering, object: query, queue: nil) {  notification in
            
            self.query.disableUpdates()
            
            guard self.query.resultCount >= 1,
                let item = self.query.results.first as? NSMetadataItem,
                let fileURL = item.value(forAttribute: NSMetadataItemURLKey) as? URL else {
                    
                    self.query.enableUpdates()
                    return completionHandler(nil)
            }
            
            completionHandler(fileURL)
            self.query.enableUpdates()
            
        }
        
        query.start()
        
    }
    
    
    /// 下载文件
    ///
    /// - Parameters:
    ///   - url: 文件URL
    ///   - completionHandler: 下载成功回调
    func downloadingFile(completionHandler: @escaping (SyncResult) -> ()) {
        
        guard let newUrl = getContainerUrl() else {
            completionHandler(.denied)
            return
        }
        
        if (!FileManager.default.isUbiquitousItem(at: newUrl)) {
            completionHandler(.fileNotExist)
            return
        }
        
        self.query.disableUpdates()
        let document = ThingsDocument(fileURL: newUrl)
        document.open { (isOpen) in
            
            if (!isOpen) {
                completionHandler(.fileNotExist)
                return
            }
            
            let fileManager = FileManager.default
            
            let newUrl = NSHomeDirectory().appending("/Documents/" + self.fileName)
            let newUrl2 = NSHomeDirectory().appending("/Documents/download.realm")
            
            fileManager.createFile(atPath: newUrl, contents: document.data, attributes: nil)
            fileManager.createFile(atPath: newUrl2, contents: document.data, attributes: nil)
            
            completionHandler(.success)
            
        }
        
        self.query.enableUpdates()
        
    }
    
    
}

class ThingsDocument: UIDocument {
    
    var data: Data = Data()
    
    convenience init(fileURL url: URL, targetFile: URL) {
        
        self.init(fileURL: url)
        self.data = try! Data(contentsOf: targetFile)
        
        
    }
    
    override func contents(forType typeName: String) throws -> Any {
        
        return self.data
        
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        self.data = contents as! Data
    }
    
}
