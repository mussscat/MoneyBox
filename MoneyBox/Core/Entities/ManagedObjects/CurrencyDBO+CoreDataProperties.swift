//
//  CurrencyDBO+CoreDataProperties.swift
//  
//
//  Created by Сергей Федоров on 06/07/2019.
//
//

import Foundation
import CoreData

extension CurrencyDBO {
    
    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var goals: NSSet?

}

// MARK: Generated accessors for goals
extension CurrencyDBO {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: SavingGoalDBO)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: SavingGoalDBO)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

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
