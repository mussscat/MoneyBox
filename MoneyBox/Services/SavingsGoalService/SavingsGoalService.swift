//
//  SavingsGoalService.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

class SavingsGoalService: ISavingsGoalService {
    
    private let storage: IStorage
    
    init(storage: IStorage) {
        self.storage = storage
    }
    
    func add(savingsGoal: SavingsGoal, completion: @escaping (Result<SavingsGoal, SavingsGoalServiceError>) -> Void) {
        self.storage.createOrUpdate(objects: [savingsGoal]) { result in
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
    
    func remove(savingsGoal: SavingsGoal, completion: @escaping (Result<Void, SavingsGoalServiceError>) -> Void) {
        self.storage.remove(objects: [savingsGoal], completion: { result in
            do {
                try result.get()
                completion(.success(()))
            } catch {
                completion(.failure(SavingsGoalServiceError.removeSavingsGoalFailed))
            }
        })
    }
    
    func update(savingsGoal: SavingsGoal, completion: @escaping ((Result<SavingsGoal, SavingsGoalServiceError>) -> Void)) {
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
    
    func fetchAllGoalsForCategory(categoryId: String, completion: @escaping (Result<[SavingsGoal], SavingsGoalServiceError>) -> Void) {
        let fetchRequest = StorageRequest<SavingsGoal>()
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
    
    func fetchAllGoals(completion: @escaping (Result<[SavingsGoal], SavingsGoalServiceError>) -> Void) {
        let fetchRequest = StorageRequest<SavingsGoal>()
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
    
    func fetchGoal(identifier: String, completion: @escaping ((Result<SavingsGoal, SavingsGoalServiceError>) -> Void)) {
        let fetchRequest = StorageRequest<SavingsGoal>()
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
