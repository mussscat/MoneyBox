//
//  CurrencyDBO+CoreDataProperties.swift
//  
//
//  Created by s.m.fedorov on 14/08/2019.
//
//

import Foundation
import CoreData
import MBStorage

extension CurrencyDBO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyDBO> {
        return NSFetchRequest<CurrencyDBO>(entityName: "CurrencyDBO")
    }

    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var goal_rel: NSSet?

}

// MARK: Generated accessors for goal_rel
extension CurrencyDBO {

    @objc(addGoal_relObject:)
    @NSManaged public func addToGoal_rel(_ value: GoalDBO)

    @objc(removeGoal_relObject:)
    @NSManaged public func removeFromGoal_rel(_ value: GoalDBO)

    @objc(addGoal_rel:)
    @NSManaged public func addToGoal_rel(_ values: NSSet)

    @objc(removeGoal_rel:)
    @NSManaged public func removeFromGoal_rel(_ values: NSSet)

}

extension CurrencyDBO: IManagedObject {
    
}

extension CurrencyDBO {
    
    static func insert(into context: NSManagedObjectContext, updateClosure: (CurrencyDBO) -> Void) -> CurrencyDBO? {
        guard let currency: CurrencyDBO = context.insertNewObject() else {
            return nil
        }
        
        updateClosure(currency)
        return currency
    }
    
    static func findCurrency(with identifier: String, in context: NSManagedObjectContext) -> CurrencyDBO? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrFetch(in: context, matching: predicate)
    }
    
    static func findOrCreateCurrency(with identifier: String, name: String, in context: NSManagedObjectContext) -> CurrencyDBO? {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        return self.findOrCreateObject(in: context, matching: predicate, configureClosure: { currency in
            currency?.name = name
            currency?.identifier = identifier
        })
    }
}
