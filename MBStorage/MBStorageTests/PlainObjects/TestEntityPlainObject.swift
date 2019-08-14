//
//  TestEntityPlainObject.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 13/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
@testable import MBStorage

struct TestEntityPlainObject: PlainObject {
    typealias Identifier = String
    typealias DBObjectType = TestEntity
    
    var identifier: Identifier
    var name: String
    var doubleValue: Double
    var category: String
    var currency: String
    
    func updateDatabaseObject(_ object: TestEntity) {
        object.identifier = self.identifier
        object.name = self.name
        object.doubleValue = self.doubleValue
        object.category = self.category
        object.currency = self.currency
    }
    
    static func createPonso(from object: TestEntity) -> TestEntityPlainObject? {
        guard
            let identifier = object.identifier,
            let name = object.name,
            let category = object.category,
            let currency = object.currency
        else {
            return nil
        }
        
        return TestEntityPlainObject(identifier: identifier,
                                     name: name,
                                     doubleValue: object.doubleValue,
                                     category: category,
                                     currency: currency)
    }
}
