//
//  SavingsGoalService.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage

public class SavingsGoalService: ISavingsGoalService {
    
    private let storage: IStorage
    
    init(storage: IStorage) {
        self.storage = storage
    }
    
    public func add(savingsGoal: Goal, completion: @escaping (Result<Goal, SavingsGoalServiceError>) -> Void) {
        self.storage.saveOrUpdate(objects: [savingsGoal]) { result in
            do {
                if let goal = try result.get().first {
                    completion(.success(goal))
                } else {
                    throw SavingsGoalServiceError.savingsGoalNotFound
                }
            } catch {
                completion(.failure(SavingsGoalServiceError.failedToAddSavingsGoal))
            }
        }
    }
    
    public func remove(savingsGoal: Goal, completion: @escaping (Result<Void, SavingsGoalServiceError>) -> Void) {
        self.storage.remove(objects: [savingsGoal], completion: { result in
            do {
                try result.get()
                completion(.success(()))
            } catch {
                completion(.failure(SavingsGoalServiceError.removeSavingsGoalFailed))
            }
        })
    }
    
    public func update(savingsGoal: Goal, completion: @escaping ((Result<Goal, SavingsGoalServiceError>) -> Void)) {
        self.storage.update(objects: [savingsGoal]) { result in
            do {
                if let goal = try result.get().first {
                    completion(.success(goal))
                } else {
                    throw SavingsGoalServiceError.savingsGoalNotFound
                }
            } catch {
                completion(.failure(SavingsGoalServiceError.updateSavingsGoalFailed))
            }
        }
    }
    
    public func fetchAllGoalsForCategory(categoryId: String, completion: @escaping (Result<[Goal], SavingsGoalServiceError>) -> Void) {
        let fetchRequest = StorageRequest<Goal>()
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", categoryId)
        self.storage.fetch(request: fetchRequest) { result in
            do {
                if let goals = try? result.get(), !goals.isEmpty {
                    completion(.success(goals))
                } else {
                    throw SavingsGoalServiceError.savingsGoalsNotFound
                }
            } catch {
                completion(.failure(SavingsGoalServiceError.fetchAllGoalsForCategoryFailed))
            }
        }
    }
    
    public func fetchAllGoals(completion: @escaping (Result<[Goal], SavingsGoalServiceError>) -> Void) {
        let fetchRequest = StorageRequest<Goal>()
        self.storage.fetch(request: fetchRequest) { result in
            do {
                if let goals = try? result.get(), !goals.isEmpty {
                    completion(.success(goals))
                } else {
                    throw SavingsGoalServiceError.savingsGoalsNotFound
                }
            } catch {
                completion(.failure(SavingsGoalServiceError.fetchAllGoalsFailed))
            }
        }
    }
    
    public func fetchGoal(identifier: String, completion: @escaping ((Result<Goal, SavingsGoalServiceError>) -> Void)) {
        let fetchRequest = StorageRequest<Goal>()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        self.storage.fetch(request: fetchRequest) { result in
            do {
                if let goal = try result.get().first {
                    completion(.success(goal))
                } else {
                    throw SavingsGoalServiceError.savingsGoalNotFound
                }
            } catch {
                completion(.failure(SavingsGoalServiceError.fetchGoalFailed))
            }
        }
    }
}
