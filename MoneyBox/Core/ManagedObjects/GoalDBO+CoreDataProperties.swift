//
//  GoalDBO+CoreDataProperties.swift
//  
//
//  Created by s.m.fedorov on 14/08/2019.
//
//

import Foundation
import CoreData
import MBStorage

extension GoalDBO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalDBO> {
        return NSFetchRequest<GoalDBO>(entityName: "GoalDBO")
    }

    @NSManaged public var categoryId: String
    @NSManaged public var currency: String
    @NSManaged public var deadline: Date
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var period: Double
    @NSManaged public var totalAmount: Double
    @NSManaged public var category_rel: GoalsCategoryDBO
    @NSManaged public var currency_rel: CurrencyDBO

}

extension GoalDBO: IManagedObject {
    
}

extension GoalDBO {
    static func insert(into context: NSManagedObjectContext, categoryId: String, currencyId: String, updateClosure: (GoalDBO) -> Void) -> GoalDBO? {
        guard let goal: GoalDBO = context.insertNewObject() else {
            return nil
        }
        
        guard
            let category = GoalsCategoryDBO.findCategory(with: categoryId, in: context),
            let currency = CurrencyDBO.findCurrency(with: currencyId, in: context)
            else {
                return nil
        }
        
        goal.category_rel = category
        goal.currency_rel = currency
        updateClosure(goal)
        
        return goal
    }
    
    func updateCategory(with identifier: String, in context: NSManagedObjectContext) {
        guard let category = GoalsCategoryDBO.findCategory(with: identifier, in: context) else {
            return
        }
        
        self.category_rel = category
    }
    
    func updateCurrency(with identifier: String, in context: NSManagedObjectContext) {
        guard let currency = CurrencyDBO.findCurrency(with: identifier, in: context) else {
            return
        }
        
        self.currency_rel = currency
    }
}
