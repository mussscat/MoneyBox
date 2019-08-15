//
//  GoalsCategoryDBO+CoreDataProperties.swift
//  
//
//  Created by s.m.fedorov on 14/08/2019.
//
//

import Foundation
import CoreData
import MBStorage

extension GoalsCategoryDBO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalsCategoryDBO> {
        return NSFetchRequest<GoalsCategoryDBO>(entityName: "GoalsCategoryDBO")
    }

    @NSManaged public var iconURL: String?
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var goals_rel: NSSet?

}

// MARK: Generated accessors for goals
extension GoalsCategoryDBO {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: GoalDBO)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: GoalDBO)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

}

extension GoalsCategoryDBO: IManagedObject {
    
}

extension GoalsCategoryDBO {
    
    static func insert(into context: NSManagedObjectContext, updateClosure: (GoalsCategoryDBO) -> Void) -> GoalsCategoryDBO? {
        guard let category: GoalsCategoryDBO = context.insertNewObject() else {
            return nil
        }
        
        updateClosure(category)
        return category
    }
    
    static func findCategory(with identifier: String, in context: NSManagedObjectContext) -> GoalsCategoryDBO? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrFetch(in: context, matching: predicate)
    }
    
    static func findOrCreateCategory(with identifier: String, name: String, iconURL: String?, in context: NSManagedObjectContext) -> GoalsCategoryDBO? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrCreateObject(in: context, matching: predicate, configureClosure: { category in
            category?.name = name
            category?.iconURL = iconURL
            category?.identifier = identifier
        })
    }
}
