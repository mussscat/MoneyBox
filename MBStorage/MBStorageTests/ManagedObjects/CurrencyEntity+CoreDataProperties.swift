//
//  CurrencyEntity+CoreDataProperties.swift
//  
//
//  Created by s.m.fedorov on 14/08/2019.
//
//

import Foundation
import CoreData
@testable import MBStorage

extension CurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
    }

    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var test_rel: NSSet?

}

// MARK: Generated accessors for test_rel
extension CurrencyEntity {

    @objc(addTest_relObject:)
    @NSManaged public func addToTest_rel(_ value: TestEntity)

    @objc(removeTest_relObject:)
    @NSManaged public func removeFromTest_rel(_ value: TestEntity)

    @objc(addTest_rel:)
    @NSManaged public func addToTest_rel(_ values: NSSet)

    @objc(removeTest_rel:)
    @NSManaged public func removeFromTest_rel(_ values: NSSet)

}

extension CurrencyEntity: IManagedObject {
    
}

extension CurrencyEntity {
    
    static func insert(into context: NSManagedObjectContext, updateClosure: (CurrencyEntity) -> Void) -> CurrencyEntity? {
        guard let currency: CurrencyEntity = context.insertNewObject() else {
            return nil
        }
        
        updateClosure(currency)
        return currency
    }
    
    static func findCurrency(with identifier: String, in context: NSManagedObjectContext) -> CurrencyEntity? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrFetch(in: context, matching: predicate)
    }
    
    static func findOrCreateCurrency(with identifier: String, name: String, in context: NSManagedObjectContext) -> CurrencyEntity? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrCreateObject(in: context, matching: predicate, configureClosure: { currency in
            currency?.name = name
            currency?.identifier = identifier
        })
    }
}
