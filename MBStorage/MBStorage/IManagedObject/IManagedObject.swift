//
//  IManagedObject.swift
//  MBStorage
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
import CoreData

public protocol IManagedObject: AnyObject, NSFetchRequestResult {
    static var entity: NSEntityDescription { get }
    static var entityName: String { get }
    static var sortDescriptors: [NSSortDescriptor] { get }
    static var predicate: NSPredicate { get }
}

public extension IManagedObject {
    static var sortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var predicate: NSPredicate {
        return NSPredicate(value: true)
    }
}

public extension IManagedObject where Self: NSManagedObject {
    static var entity: NSEntityDescription {
        return self.entity()
    }
    
    static var entityName: String {
        return self.entity.name ?? String(describing: self)
    }
    
    static func findOrCreateObject(in context: NSManagedObjectContext, matching predicate: NSPredicate, configureClosure: (Self?) -> ()) -> Self? {
        guard let object = self.findOrFetch(in: context, matching: predicate) else {
            let newObject = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: context) as? Self
            configureClosure(newObject)
            return newObject
        }
        
        return object
    }
    
    
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = self.materializedObject(in: context, matching: predicate) else {
            let request = NSFetchRequest<Self>(entityName: self.entityName)
            request.predicate = predicate
            request.returnsObjectsAsFaults = false
            request.fetchLimit = 1
            return try? context.fetch(request).first
        }
        
        return object
    }
    
    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else {
                continue
            }
            
            return result
        }
        
        return nil
    }
}
