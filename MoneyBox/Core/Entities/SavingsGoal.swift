//
//  SavingsGoal.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage

public struct SavingsGoal: Identifiable, Codable {
    public var identifier: String
    public var categoryId: String
    public var totalAmount: Double
    public var name: String
    public var currency: String
    public var deadline: Date?
    public var period: Double?
    
    public init(categoryId: String,
                totalAmount: Double,
                name: String,
                currency: Currency,
                deadline: Date? = nil,
                period: Double? = 0) {
        self.identifier = UUID().uuidString
        self.totalAmount = totalAmount
        self.name = name
        self.currency = currency.identifier
        self.categoryId = categoryId
        self.deadline = deadline
        self.period = period
    }
    
    public init(identifier: String,
                categoryId: String,
                totalAmount: Double,
                name: String,
                currency: String,
                deadline: Date? = nil,
                period: Double? = 0) {
        self.identifier = identifier
        self.totalAmount = totalAmount
        self.name = name
        self.currency = currency
        self.categoryId = categoryId
        self.deadline = deadline
        self.period = period
    }
}

extension SavingsGoal: Convertible {
    
    public typealias DBObjectType = SavingGoalDBO
    
    public func updateDatabaseObject(_ object: DBObjectType) {
        object.totalAmount = self.totalAmount
        object.identifier = self.identifier
        object.name = self.name
        object.currency = self.currency
        object.period = self.period ?? 0
        object.deadline = self.deadline
        object.categoryId = self.categoryId
    }
    
    public static func createPonso(from object: DBObjectType) -> SavingsGoal? {
        guard
            let identifier = object.identifier,
            let name = object.name,
            let currency = object.currency,
            let categoryId = object.categoryId
        else {
            return nil
        }
        
        return SavingsGoal(identifier: identifier,
                           categoryId: categoryId,
                           totalAmount: object.totalAmount,
                           name: name,
                           currency: currency,
                           deadline: object.deadline,
                           period: object.period)
    }
}
