//
//  ThreeThings+CoreDataProperties.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/13.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import Foundation
import CoreData


extension ThreeThings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ThreeThings> {
        return NSFetchRequest<ThreeThings>(entityName: "ThreeThings");
    }

    @NSManaged public var firstThing: String?
    @NSManaged public var secondThing: String?
    @NSManaged public var threeThing: String?
    @NSManaged public var writeDate: NSDate?
    @NSManaged public var isFinish: Bool

}
