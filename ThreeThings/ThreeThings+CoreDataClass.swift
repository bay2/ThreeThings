//
//  ThreeThings+CoreDataClass.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/13.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import CoreData
import Datez


public class ThreeThings: NSManagedObject {
    
    static func fetchData(predicate: NSPredicate) -> [ThreeThings] {
        
        let fetchRequest = NSFetchRequest<ThreeThings>(entityName: "ThreeThings")
        
        fetchRequest.predicate = predicate
        
        do {
            let result =  try managedContext.fetch(fetchRequest)
            return result
            
        } catch let error1 as NSError {
            print("Error: \(error1)")
        }
        
        return []
        
    }
    
    static func fetchTodayData() -> ThreeThings? {
        
        
        let predicate = NSPredicate(format: "writeDate >= %@ AND writeDate <= %@", Date().gregorian.beginningOfHour.date as NSDate, (Date().gregorian.beginningOfHour + 24.hour).date as NSDate)
        
        return ThreeThings.fetchData(predicate: predicate).first
        
    }
    
    static func fetchFinishData() -> [ThreeThings] {
        
        let predicate = NSPredicate(format: "isFinish == YES")

        return ThreeThings.fetchData(predicate: predicate)
    }
    
    static func addTodayData(_ closure: (ThreeThings) -> ()) {
        
        do {
            
            if let result = ThreeThings.fetchTodayData() {
                
                closure(result)
                
                try managedContext.save()
                
                
            } else {
                
                guard let model = NSEntityDescription.insertNewObject(forEntityName: "ThreeThings", into: managedContext) as? ThreeThings  else {
                    fatalError()
                }
                
                closure(model)
                
                try managedContext.save()
                
            }

        } catch let error1 as NSError {
            print("Error: \(error1)")
        }
        
        
        
    }

}
