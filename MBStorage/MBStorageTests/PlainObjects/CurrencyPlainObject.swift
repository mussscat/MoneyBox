//
//  CurrencyPlainObject.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
import CoreData
@testable import MBStorage

struct CurrencyPlainObject: PlainObject {
    typealias Identifier = String
    typealias DBObjectType = CurrencyEntity
    
    var identifier: Identifier
    var name: String
    
    public func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.name = self.name
        object.identifier = self.identifier
    }
    
    public static func createPlainObject(from object: DBObjectType) -> CurrencyPlainObject? {
        return CurrencyPlainObject(identifier: object.identifier,
                                   name: object.name)
    }
    
    public func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        return DBObjectType.insert(into: context, updateClosure: { currency in
            self.updateManagedObject(currency, in: context)
        })
    }
}
