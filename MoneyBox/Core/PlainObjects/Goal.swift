//
//  Goal.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage
import CoreData

public struct Goal: Identifiable {
    public var identifier: String
    public var category: GoalCategory
    public var totalAmount: Double
    public var name: String
    public var currency: Currency?
    public var deadline: Date
    public var period: Double
    
    init(identifier: Identifier,
         category: GoalCategory,
         totalAmount: Double,
         name: String,
         currency: Currency?,
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
    
    init(category: GoalCategory,
         totalAmount: Double,
         name: String,
         currency: Currency?,
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

extension Goal: Convertible {
    
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
    
    public static func createPlainObject(from object: DBObjectType) -> Goal? {
        guard let category = GoalCategory.createPlainObject(from: object.category_rel) else {
            return nil
        }
        
        var currency: Currency?
        if let currency_rel = object.currency_rel {
           currency = Currency.createPlainObject(from: currency_rel)
        }
        
        return Goal(identifier: object.identifier,
                               category: category,
                               totalAmount: object.totalAmount,
                               name: object.name,
                               currency: currency,
                               deadline: object.deadline,
                               period: object.period)
    }
}

extension Goal: Equatable {
    static public func ==(rhs: Goal, lhs: Goal) -> Bool {
        return rhs.identifier == lhs.identifier
    }
}
