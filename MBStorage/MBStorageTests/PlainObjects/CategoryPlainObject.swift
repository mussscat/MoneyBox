//
//  CategoryPlainObject.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
import CoreData
@testable import MBStorage

struct CategoryPlainObject: PlainObject {
    typealias Identifier = String
    typealias DBObjectType = CategoryEntity
    
    var identifier: Identifier
    var name: String

    public func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        return DBObjectType.insert(into: context, updateClosure: { category in
            self.updateManagedObject(category, in: context)
        })
    }
    
    public func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.identifier = self.identifier
        object.name = self.name
    }
    
    public static func createPlainObject(from object: DBObjectType) -> CategoryPlainObject? {
        return CategoryPlainObject(identifier: object.identifier,
                                   name: object.name)
    }
}
