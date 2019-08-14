//
//  TestEntityPlainObject.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 13/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
import CoreData
@testable import MBStorage

struct TestEntityPlainObject: PlainObject {

    typealias Identifier = String
    typealias DBObjectType = TestEntity
    
    var identifier: Identifier
    var name: String
    var doubleValue: Double
    var category: CategoryPlainObject
    var currency: CurrencyPlainObject?
    
    func updateManagedObject(_ object: TestEntity, in context: NSManagedObjectContext) {
        object.identifier = self.identifier
        object.name = self.name
        object.doubleValue = self.doubleValue
        
        if object.category_rel.identifier != self.category.identifier {
            object.updateCategory(with: self.category.identifier, in: context)
        }
        
        if let currency = self.currency, object.currency_rel?.identifier != currency.identifier {
            object.updateCurrency(with: currency.identifier, in: context)
        }
    }
    
    func createManagedObject(in context: NSManagedObjectContext) -> TestEntity? {
        guard let currency = self.currency else {
            return nil
        }
        
        return TestEntity.insert(into: context,
                                 categoryId: self.category.identifier,
                                 currencyId: currency.identifier,
                                 updateClosure: { testObject in
            self.updateManagedObject(testObject, in: context)
        })
    }
    
    public static func createPlainObject(from object: DBObjectType) -> TestEntityPlainObject? {
        guard
            let currency_rel = object.currency_rel,
            let category = CategoryPlainObject.createPlainObject(from: object.category_rel),
            let currency = CurrencyPlainObject.createPlainObject(from: currency_rel)
        else {
            return nil
        }
        
        return TestEntityPlainObject(identifier: object.identifier,
                                     name: object.name,
                                     doubleValue: object.doubleValue,
                                     category: category,
                                     currency: currency)
    }
}
