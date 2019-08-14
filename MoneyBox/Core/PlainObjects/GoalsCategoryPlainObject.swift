//
//  GoalsCategoryPlainObject.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage
import CoreData

public struct GoalsCategoryPlainObject: Identifiable, Codable {
    public var identifier: String
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

extension GoalsCategoryPlainObject: Convertible {
    
    public typealias DBObjectType = GoalsCategoryDBO
    
    public func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType? {
        return DBObjectType.insert(into: context, updateClosure: { category in
            self.updateManagedObject(category, in: context)
        })
    }
    
    public func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext) {
        object.identifier = self.identifier
        object.name = self.name
        object.iconURL = self.iconURL
    }
    
    public static func createPlainObject(from object: DBObjectType) -> GoalsCategoryPlainObject {
        return GoalsCategoryPlainObject(identifier: object.identifier,
                                        name: object.name,
                                        iconURL: object.iconURL)
    }
}

extension GoalsCategoryPlainObject: Equatable {
    static public func ==(rhs: GoalsCategoryPlainObject, lhs: GoalsCategoryPlainObject) -> Bool {
        return rhs.identifier == lhs.identifier
    }
}
