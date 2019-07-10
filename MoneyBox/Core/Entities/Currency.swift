//
//  Currency.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 18.12.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

struct Currency: Identifiable, Codable {
    var identifier: String
    var name: String
    
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

extension Currency: Convertible {
    
    typealias DBObjectType = CurrencyDBO
    
    func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.name = self.name
        object.identifier = self.identifier
    }
    
    static func createPlainObject(from object: DBObjectType) -> Currency {
        return Currency(identifier: object.identifier,
                        name: object.name)
    }
    
    func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        return DBObjectType.insert(into: context, updateClosure: { currency in
            self.updateManagedObject(currency, in: context)
        })
    }
    
}
