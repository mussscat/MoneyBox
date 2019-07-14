//
//  SavingGoalDBO+CoreDataProperties.swift
//  
//
//  Created by Сергей Федоров on 06/07/2019.
//
//

import Foundation
import CoreData

extension SavingGoalDBO {
    @NSManaged public var deadline: Date
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var period: Double
    @NSManaged public var totalAmount: Double
    @NSManaged public var category: SavingGoalCategoryDBO
    @NSManaged public var currency: CurrencyDBO
}

extension SavingGoalDBO: IManagedObject {
    
}

extension SavingGoalDBO {
    static func insert(into context: NSManagedObjectContext, categoryId: String, currencyId: String, updateClosure: (SavingGoalDBO) -> Void) -> SavingGoalDBO? {
        guard let goal: SavingGoalDBO = context.insertNewObject() else {
            return nil
        }
        
        guard
            let category = SavingGoalCategoryDBO.findCategory(with: categoryId, in: context),
            let currency = CurrencyDBO.findCurrency(with: currencyId, in: context)
        else {
            return nil
        }
        
        goal.category = category
        goal.currency = currency
        updateClosure(goal)
        
        return goal
    }
    
    func updateCategory(with identifier: String, in context: NSManagedObjectContext) {
        guard let category = SavingGoalCategoryDBO.findCategory(with: identifier, in: context) else {
            return
        }
        
        self.category = category
    }
    
    func updateCurrency(with identifier: String, in context: NSManagedObjectContext) {
        guard let currency = CurrencyDBO.findCurrency(with: identifier, in: context) else {
            return
        }
        
        self.currency = currency
    }
}
