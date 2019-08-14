//
//  NSManagedObjectContext+IManagedObject.swift
//  MBStorage
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//


import Foundation
import CoreData

public extension NSManagedObjectContext {
    func insertNewObject<T: IManagedObject>() -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T
    }
}
