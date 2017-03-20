//
//  DataAccess.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/16.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import CoreData


class DataAccess: NSObject {
    
    fileprivate static let instance = DataAccess()
    public class var sharedInstance : DataAccess {
        return instance
    }
    
    lazy var managerObjectModel: NSManagedObjectModel = {
        
        let modekURL = Bundle.main.url(forResource: "ThreeThings", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modekURL)!
        
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? =  {
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managerObjectModel)
        
        var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.simcai.ThreeThings.beta")!
        
        url.appendPathComponent("ThreeThings.sqlite")
        
        
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSPersistentStoreUbiquitousContentNameKey:"MyAppCloudStore"])
        } catch let error1 as NSError {
            
            coordinator = nil
            
            print("Error: \(error1.domain)")
            
        }
        
        return coordinator
        
    }()
    
    override init() {
        super.init()
        
        let dc = NotificationCenter.default
        dc.addObserver(forName: Notification.Name.NSPersistentStoreCoordinatorStoresWillChange, object: self.persistentStoreCoordinator, queue: OperationQueue.main, using: { _ in
            
            managedContext.perform({ () -> Void in

                if managedContext.hasChanges {
                    do {
                        try managedContext.save()
                    } catch let error1 as NSError {
                        print("\(error1)")
                    }
                    
                }
                managedContext.reset()
            })
            
        })
        
        dc.addObserver(forName: Notification.Name.NSPersistentStoreCoordinatorStoresDidChange, object: self, queue: OperationQueue.main, using: { _ in
            managedContext.perform({ () -> Void in
                var error: NSError? = nil
                if managedContext.hasChanges {
                    do {
                        try managedContext.save()
                    } catch let error1 as NSError {
                        print("\(error1)")
                    }
                    
                }
            })
        })
        
        dc.addObserver(forName: Notification.Name.NSPersistentStoreDidImportUbiquitousContentChanges, object: self, queue: OperationQueue.main, using: { note in
            managedContext.perform {
                managedContext.mergeChanges(fromContextDidSave: note)
            }
        })

        
        
    }
    
}
