//
//  SavingsGoalService_protocol.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

public enum SavingsGoalServiceError: Error {
    case savingsGoalNotFound
    case savingsGoalsNotFound
    case failedToAddSavingsGoal
    case removeSavingsGoalFailed
    case updateSavingsGoalFailed
    case fetchAllGoalsForCategoryFailed
    case fetchAllGoalsFailed
    case fetchGoalFailed
}

public protocol ISavingsGoalService: class {
    func add(savingsGoal: SavingsGoal, completion: @escaping ((Result<SavingsGoal, SavingsGoalServiceError>) -> Void))
    func remove(savingsGoal: SavingsGoal, completion: @escaping ((Result<Void, SavingsGoalServiceError>) -> Void))
    func update(savingsGoal: SavingsGoal, completion: @escaping ((Result<SavingsGoal, SavingsGoalServiceError>) -> Void))
    func fetchAllGoalsForCategory(categoryId: String, completion: @escaping ((Result<[SavingsGoal], SavingsGoalServiceError>) -> Void))
    func fetchAllGoals(completion: @escaping ((Result<[SavingsGoal], SavingsGoalServiceError>) -> Void))
    func fetchGoal(identifier: String, completion: @escaping ((Result<SavingsGoal, SavingsGoalServiceError>) -> Void))
}
