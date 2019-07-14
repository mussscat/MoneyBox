//
//  SavingsGoalService.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 25.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import PromiseKit

class SavingsGoalService: ISavingsGoalService {
    
    private let storage: IStorage
    
    init(storage: IStorage) {
        self.storage = storage
    }
    
    func add(savingsGoal: SavingsGoal, completion: @escaping (Swift.Result<SavingsGoal, SavingsGoalServiceError>) -> Void) {
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
    
    func remove(savingsGoal: SavingsGoal, completion: @escaping (Swift.Result<Void, SavingsGoalServiceError>) -> Void) {
        self.storage.remove(objects: [savingsGoal], completion: { result in
            do {
                try result.get()
                completion(.success(()))
            } catch {
                completion(.failure(SavingsGoalServiceError.removeSavingsGoalFailed))
            }
        })
    }
    
    func update(savingsGoal: SavingsGoal, completion: @escaping ((Swift.Result<SavingsGoal, SavingsGoalServiceError>) -> Void)) {
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
    
    func fetchAllGoalsForCategory(categoryId: String, completion: @escaping (Swift.Result<[SavingsGoal], SavingsGoalServiceError>) -> Void) {
        let fetchRequest = StorageRequest<SavingsGoal>()
        fetchRequest.predicate = NSPredicate(format: "category.identifier == %@", categoryId)
        self.storage.fetch(request: fetchRequest) { result in
            do {
                let goals = try result.get()
                completion(.success(goals))
            } catch {
                completion(.failure(SavingsGoalServiceError.fetchAllGoalsForCategoryFailed))
            }
        }
    }
    
    func fetchAllGoals(completion: @escaping (Swift.Result<[SavingsGoal], SavingsGoalServiceError>) -> Void) {
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
    
    func fetchGoal(identifier: String, completion: @escaping ((Swift.Result<SavingsGoal, SavingsGoalServiceError>) -> Void)) {
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
    
    func fetchAllGoalsContainers(completion: @escaping (Swift.Result<[GoalsContainer], SavingsGoalServiceError>) -> Void) {
        firstly { () -> Promise<[SavingsGoalCategory]> in
            let categoriesFetchRequest = StorageRequest<SavingsGoalCategory>()
            return self.storage.fetch(request: categoriesFetchRequest)
        }
        .then { categories -> Promise<[(SavingsGoalCategory, [SavingsGoal])]> in
            var promises = [Promise<(SavingsGoalCategory, [SavingsGoal])>]()
            categories.forEach { category in
                let promise = self.fetchAllGoalsForCategory(categoryId: category.identifier).map { (category, $0) }
                promises.append(promise)
            }
            return when(fulfilled: promises)
        }
        .done { arg in
            let containers = arg.map { GoalsContainer(category: $0.0, goals: $0.1) }
            completion(.success(containers))
        }
        .catch { _ in
            completion(.failure(SavingsGoalServiceError.fetchAllGoalsContainersFailed))
        }
    }
    
    func fetchGoalsContainer(categoryId: String, completion: @escaping (Swift.Result<GoalsContainer, SavingsGoalServiceError>) -> Void) {
        firstly { () -> Promise<SavingsGoalCategory> in
            return self.storage.fetchObject(with: categoryId)
        }
        .then { category -> Promise<(SavingsGoalCategory, [SavingsGoal])> in
            return self.fetchAllGoalsForCategory(categoryId: category.identifier).map { (category, $0) }
        }
        .done { arg in
            let container = GoalsContainer(category: arg.0, goals: arg.1)
            completion(.success(container))
        }
        .catch { _ in
            completion(.failure(SavingsGoalServiceError.fetchGoalsContainerFailed))
        }
    }
}
