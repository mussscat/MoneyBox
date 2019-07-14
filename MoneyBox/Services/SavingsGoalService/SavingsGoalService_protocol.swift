//
//  SavingsGoalService_protocol.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import PromiseKit

enum SavingsGoalServiceError: Error {
    case savingsGoalNotFound
    case savingsGoalsNotFound
    case failedToAddSavingsGoal
    case removeSavingsGoalFailed
    case updateSavingsGoalFailed
    case fetchAllGoalsForCategoryFailed
    case fetchAllGoalsFailed
    case fetchGoalFailed
    case fetchAllGoalsContainersFailed
    case fetchGoalsContainerFailed
}

protocol ISavingsGoalService: class {
    func add(savingsGoal: SavingsGoal, completion: @escaping (Swift.Result<SavingsGoal, SavingsGoalServiceError>) -> Void)
    func remove(savingsGoal: SavingsGoal, completion: @escaping (Swift.Result<Void, SavingsGoalServiceError>) -> Void)
    func update(savingsGoal: SavingsGoal, completion: @escaping (Swift.Result<SavingsGoal, SavingsGoalServiceError>) -> Void)
    func fetchAllGoalsForCategory(categoryId: String, completion: @escaping (Swift.Result<[SavingsGoal], SavingsGoalServiceError>) -> Void)
    func fetchAllGoals(completion: @escaping (Swift.Result<[SavingsGoal], SavingsGoalServiceError>) -> Void)
    func fetchGoal(identifier: String, completion: @escaping (Swift.Result<SavingsGoal, SavingsGoalServiceError>) -> Void)
    func fetchAllGoalsContainers(completion: @escaping (Swift.Result<[GoalsContainer], SavingsGoalServiceError>) -> Void)
    func fetchGoalsContainer(categoryId: String, completion: @escaping (Swift.Result<GoalsContainer, SavingsGoalServiceError>) -> Void)
}

extension ISavingsGoalService {
    func fetchAllGoalsForCategory(categoryId: String) -> Promise<[SavingsGoal]> {
        return Promise<[SavingsGoal]> { resolver in
            self.fetchAllGoalsForCategory(categoryId: categoryId, completion: { result in
                do {
                    let goals = try result.get()
                    resolver.fulfill(goals)
                } catch {
                    resolver.reject(error)
                }
            })
        }
    }
}
