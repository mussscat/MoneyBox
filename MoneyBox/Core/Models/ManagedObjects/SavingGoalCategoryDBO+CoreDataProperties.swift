//
//  SavingGoalCategoryDBO+CoreDataProperties.swift
//  
//
//  Created by Сергей Федоров on 06/07/2019.
//
//

import Foundation
import CoreData

extension SavingGoalCategoryDBO {
    @NSManaged public var iconURL: String?
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var goals: NSSet?

}

// MARK: Generated accessors for goals
extension SavingGoalCategoryDBO {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: SavingGoalDBO)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: SavingGoalDBO)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

}

extension SavingGoalCategoryDBO: IManagedObject {
    
}

extension SavingGoalCategoryDBO {
    
    static func insert(into context: NSManagedObjectContext, updateClosure: (SavingGoalCategoryDBO) -> Void) -> SavingGoalCategoryDBO? {
        guard let category: SavingGoalCategoryDBO = context.insertNewObject() else {
            return nil
        }
        
        updateClosure(category)
        return category
    }
    
    static func findCategory(with identifier: String, in context: NSManagedObjectContext) -> SavingGoalCategoryDBO? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrFetch(in: context, matching: predicate)
    }
    
    static func findOrCreateCategory(with identifier: String, name: String, iconURL: String?, in context: NSManagedObjectContext) -> SavingGoalCategoryDBO? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrCreateObject(in: context, matching: predicate, configureClosure: { category in
            category?.name = name
            category?.iconURL = iconURL
            category?.identifier = identifier
        })
    }
}
