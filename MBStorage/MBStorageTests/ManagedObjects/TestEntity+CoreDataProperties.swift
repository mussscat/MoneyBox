//
//  TestEntity+CoreDataProperties.swift
//  
//
//  Created by s.m.fedorov on 14/08/2019.
//
//

import Foundation
import CoreData
@testable import MBStorage

extension TestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        return NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var doubleValue: Double
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var category_rel: CategoryEntity
    @NSManaged public var currency_rel: CurrencyEntity?

}

extension TestEntity: IManagedObject {
    
}

extension TestEntity {
    static func insert(into context: NSManagedObjectContext, categoryId: String, currencyId: String, updateClosure: (TestEntity) -> Void) -> TestEntity? {
        guard let goal: TestEntity = context.insertNewObject() else {
            return nil
        }
        
        guard
            let category = CategoryEntity.findCategory(with: categoryId, in: context),
            let currency = CurrencyEntity.findCurrency(with: currencyId, in: context)
            else {
                return nil
        }
        
        goal.category_rel = category
        goal.currency_rel = currency
        updateClosure(goal)
        
        return goal
    }
    
    func updateCategory(with identifier: String, in context: NSManagedObjectContext) {
        guard let category = CategoryEntity.findCategory(with: identifier, in: context) else {
            return
        }
        
        self.category_rel = category
    }
    
    func updateCurrency(with identifier: String, in context: NSManagedObjectContext) {
        guard let currency = CurrencyEntity.findCurrency(with: identifier, in: context) else {
            return
        }
        
        self.currency_rel = currency
    }
}
