//
//  GoalPlainObject.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage
import CoreData

public struct GoalPlainObject: Identifiable {
    public var identifier: String
    public var category: GoalsCategoryPlainObject
    public var totalAmount: Double
    public var name: String
    public var currency: CurrencyPlainObject?
    public var deadline: Date
    public var period: Double
    
    init(identifier: Identifier,
         category: GoalsCategoryPlainObject,
         totalAmount: Double,
         name: String,
         currency: CurrencyPlainObject,
         deadline: Date,
         period: Double) {
        self.identifier = identifier
        self.category = category
        self.totalAmount = totalAmount
        self.name = name
        self.currency = currency
        self.deadline = deadline
        self.period = period
    }
    
    init(category: GoalsCategoryPlainObject,
         totalAmount: Double,
         name: String,
         currency: CurrencyPlainObject,
         deadline: Date,
         period: Double) {
        self.identifier = UUID().uuidString
        self.category = category
        self.totalAmount = totalAmount
        self.name = name
        self.currency = currency
        self.deadline = deadline
        self.period = period
    }
}

extension GoalPlainObject: Convertible {
    
    public typealias DBObjectType = GoalDBO
    
    public func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.totalAmount = self.totalAmount
        object.identifier = self.identifier
        object.name = self.name
        object.period = self.period
        object.deadline = self.deadline
        
        if object.category_rel.identifier != self.category.identifier {
            object.updateCategory(with: self.category.identifier, in: context)
        }
        
        if let currency = self.currency, object.currency_rel?.identifier != currency.identifier {
            object.updateCurrency(with: currency.identifier, in: context)
        }
    }
    
    public func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        guard let currency = self.currency else {
            return nil
        }
        
        return DBObjectType.insert(into: context,
                                   categoryId: self.category.identifier,
                                   currencyId: currency.identifier,
                                   updateClosure: { goalObject in
                                self.updateManagedObject(goalObject, in: context)
        })
    }
    
    public static func createPlainObject(from object: DBObjectType) -> GoalPlainObject? {
        guard
            let currency_rel = object.currency_rel,
            let category = GoalsCategoryPlainObject.createPlainObject(from: object.category_rel),
            let currency = CurrencyPlainObject.createPlainObject(from: currency_rel)
        else {
            return nil
        }
        
        return GoalPlainObject(identifier: object.identifier,
                               category: category,
                               totalAmount: object.totalAmount,
                               name: object.name,
                               currency: currency,
                               deadline: object.deadline,
                               period: object.period)
    }
}

extension GoalPlainObject: Equatable {
    static public func ==(rhs: GoalPlainObject, lhs: GoalPlainObject) -> Bool {
        return rhs.identifier == lhs.identifier
    }
}
