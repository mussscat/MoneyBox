//
//  SavingsGoalCategory.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

public struct SavingsGoalCategory: Identifiable, Codable {
    public var identifier: String
    public var name: String
    public var iconURL: String
    public var sortOrder: Int16
    
    init(identifier: String,
         name: String,
         iconURL: String,
         sortOrder: Int16) {
        self.identifier = identifier
        self.name = name
        self.iconURL = iconURL
        self.sortOrder = sortOrder
    }
}

extension SavingsGoalCategory: Convertible {
    
    public typealias DBObjectType = SavingGoalCategoryDBO
    
    public func updateDatabaseObject(_ object: DBObjectType) {
        object.identifier = self.identifier
        object.name = self.name
        object.iconURL = self.iconURL
        object.sortOrder = self.sortOrder
    }
    
    public static func createPonso(from object: DBObjectType) -> SavingsGoalCategory? {
        guard
            let identifier = object.identifier,
            let name = object.name,
            let url = object.iconURL
        else {
            return nil
        }

        return SavingsGoalCategory(identifier: identifier,
                                   name: name,
                                   iconURL: url,
                                   sortOrder: object.sortOrder)
    }
}
