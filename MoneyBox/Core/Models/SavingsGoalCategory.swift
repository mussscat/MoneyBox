//
//  SavingsGoalCategory.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData
import IGListKit

final class SavingsGoalCategory: Identifiable, Codable {
    var identifier: String
    var name: String
    var iconURL: String?
    
    init(identifier: String,
         name: String,
         iconURL: String?) {
        self.identifier = identifier
        self.name = name
        self.iconURL = iconURL
    }
    
    init(name: String,
         iconURL: String?) {
        self.identifier = UUID().uuidString
        self.name = name
        self.iconURL = iconURL
    }
}

extension SavingsGoalCategory: Convertible {

    typealias DBObjectType = SavingGoalCategoryDBO
    
    func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        return DBObjectType.insert(into: context, updateClosure: { category in
            self.updateManagedObject(category, in: context)
        })
    }
    
    func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.identifier = self.identifier
        object.name = self.name
        object.iconURL = self.iconURL
    }
    
    static func createPlainObject(from object: DBObjectType) -> SavingsGoalCategory {
        return SavingsGoalCategory(identifier: object.identifier,
                                   name: object.name,
                                   iconURL: object.iconURL)
    }
}

extension SavingsGoalCategory: Equatable {
    static public func ==(rhs: SavingsGoalCategory, lhs: SavingsGoalCategory) -> Bool {
        return rhs.identifier == lhs.identifier
    }
}

extension SavingsGoalCategory: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SavingsGoalCategory else {
            return false
        }
        
        return self == object
    }
}