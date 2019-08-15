//
//  CategoryEntity+CoreDataProperties.swift
//  
//
//  Created by s.m.fedorov on 14/08/2019.
//
//

import Foundation
import CoreData
@testable import MBStorage

extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var identifier: String
    @NSManaged public var test_rel: NSSet?

}

// MARK: Generated accessors for test_rel
extension CategoryEntity {

    @objc(addTest_relObject:)
    @NSManaged public func addToTest_rel(_ value: TestEntity)

    @objc(removeTest_relObject:)
    @NSManaged public func removeFromTest_rel(_ value: TestEntity)

    @objc(addTest_rel:)
    @NSManaged public func addToTest_rel(_ values: NSSet)

    @objc(removeTest_rel:)
    @NSManaged public func removeFromTest_rel(_ values: NSSet)

}

extension CategoryEntity: IManagedObject {
    
}

extension CategoryEntity {
    
    static func insert(into context: NSManagedObjectContext, updateClosure: (CategoryEntity) -> Void) -> CategoryEntity? {
        guard let category: CategoryEntity = context.insertNewObject() else {
            return nil
        }
        
        updateClosure(category)
        return category
    }
    
    static func findCategory(with identifier: String, in context: NSManagedObjectContext) -> CategoryEntity? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrFetch(in: context, matching: predicate)
    }
    
    static func findOrCreateCategory(with identifier: String, name: String, iconURL: String?, in context: NSManagedObjectContext) -> CategoryEntity? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrCreateObject(in: context, matching: predicate, configureClosure: { category in
            category?.name = name
            category?.identifier = identifier
        })
    }
}
