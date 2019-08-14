//
//  CurrencyPlainObject.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 18.12.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage
import CoreData

public struct CurrencyPlainObject: Identifiable, Codable {
    public var identifier: String
    public var name: String
    
    init(identifier: String,
         name: String) {
        self.identifier = identifier
        self.name = name
    }
    
    init(name: String) {
        self.identifier = UUID().uuidString
        self.name = name
    }
}

extension CurrencyPlainObject: Convertible {

    public typealias DBObjectType = CurrencyDBO
    
    public func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.name = self.name
        object.identifier = self.identifier
    }
    
    public static func createPlainObject(from object: DBObjectType) -> CurrencyPlainObject {
        return CurrencyPlainObject(identifier: object.identifier,
                                   name: object.name)
    }
    
    public func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        return DBObjectType.insert(into: context, updateClosure: { currency in
            self.updateManagedObject(currency, in: context)
        })
    }
}

extension CurrencyPlainObject: Equatable {
    static public func ==(rhs: CurrencyPlainObject, lhs: CurrencyPlainObject) -> Bool {
        return rhs.identifier == lhs.identifier
    }
}
