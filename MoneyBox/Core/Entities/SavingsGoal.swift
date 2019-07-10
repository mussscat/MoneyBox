//
//  SavingsGoal.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

struct SavingsGoal: Identifiable {
    private(set) var identifier: String
    var category: SavingsGoalCategory
    var totalAmount: Double
    var name: String
    var currency: Currency
    var deadline: Date
    var period: Double
    
    init(identifier: Identifier,
         category: SavingsGoalCategory,
         totalAmount: Double,
         name: String,
         currency: Currency,
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
    
    init(category: SavingsGoalCategory,
         totalAmount: Double,
         name: String,
         currency: Currency,
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

extension SavingsGoal: Convertible {
    
    typealias DBObjectType = SavingGoalDBO
    
    func updateManagedObject(_ object: SavingGoalDBO, in context: NSManagedObjectContext) {
        object.totalAmount = self.totalAmount
        object.identifier = self.identifier
        object.name = self.name
        object.period = self.period
        object.deadline = self.deadline
        
        if object.category.identifier != self.category.identifier {
            object.updateCategory(with: self.category.identifier, in: context)
        }
        
        if object.currency.identifier != self.currency.identifier {
            object.updateCurrency(with: self.currency.identifier, in: context)
        }
    }
    
    func createManagedObject(in context: NSManagedObjectContext) -> SavingGoalDBO? {
        return SavingGoalDBO.insert(into: context,
                                    categoryId: self.category.identifier,
                                    currencyId: self.currency.identifier,
                                    updateClosure: { goalObject in
                                        self.updateManagedObject(goalObject, in: context)
        })
    }
    
    static func createPlainObject(from object: DBObjectType) -> SavingsGoal {
        let category = SavingsGoalCategory.createPlainObject(from: object.category)
        let currency = Currency.createPlainObject(from: object.currency)
        
        return SavingsGoal(identifier: object.identifier,
                           category: category,
                           totalAmount: object.totalAmount,
                           name: object.name,
                           currency: currency, deadline: object.deadline,
                           period: object.period)
    }
}
