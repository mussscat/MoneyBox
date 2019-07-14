//
//  CoreDataStack.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: ICoreDataStack {
    
    private enum Constants {
        static let dbExtension = "momd"
        static let dispatchQueueLabel = "com.moneybox.coreData"
    }
    
    private var persistentStoreContainer: NSPersistentContainer?
    private let dispatchQueue = DispatchQueue(label: Constants.dispatchQueueLabel)
    
    private let dbName: String
    private let bundle: Bundle
    
    init(dbName: String, bundle: Bundle) {
        self.dbName = dbName
        self.bundle = bundle
    }
    
    // MARK: CoreDataStack protocol implementation
    
    func execute<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) throws -> [T] {
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            throw CoreDataStackError.executeFetchRequestFailed
        }
    }
    
    func execute<T>(transaction: @escaping ((NSManagedObjectContext) throws -> T), completion: @escaping ((Swift.Result<T, Error>) -> Void)) {
        self.dispatchQueue.async {
            let result = self.unsafeExecuteSyncTransaction(transaction)
            switch result {
            case let .success(value):
                DispatchQueue.main.async {
                    completion(.success(value))
                }
            case .failure:
                DispatchQueue.main.async {
                    completion(.failure(CoreDataStackError.executeAsyncTransactionFailed))
                }
            }
        }
    }
    
    private func unsafeExecuteSyncTransaction<T>(_ transaction: @escaping (NSManagedObjectContext) throws -> T) -> Swift.Result<T, Error> {
        do {
            let context = try self.getBackgroundContext()
            var result = Swift.Result<T, Error>.failure(CoreDataStackError.executeSyncTransactionFailed)
            context.performAndWait {
                do {
                    let returnValue = try transaction(context)
                    result = .success(returnValue)
                    if context.hasChanges {
                        try context.save()
                    }
                } catch {
                    result = .failure(error)
                    context.rollback()
                }
            }
            
            return result
        } catch {
            return .failure(CoreDataStackError.unsafeExecuteSyncTransactionFailed)
        }
    }
    
    func setupStack(completion: ((Swift.Result<Void, Error>) -> Void)?) {
        do {
            self.persistentStoreContainer = try self.createPersistentStoreContainer()
            self.persistentStoreContainer?.loadPersistentStores { _, error in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.success(()))
                }
            }
        } catch {
            completion?(.failure(CoreDataStackError.setupStackFailed))
        }
    }
    
    // MARK: Contexts creation
    
    private func getMainContext() throws -> NSManagedObjectContext {
        guard let context = self.persistentStoreContainer?.viewContext else {
            throw CoreDataStackError.gettingMainContextFailed
        }
        
        context.shouldDeleteInaccessibleFaults = true
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }
    
    private func getBackgroundContext() throws -> NSManagedObjectContext {
        guard let context = self.persistentStoreContainer?.newBackgroundContext() else {
            throw CoreDataStackError.gettingBackgroundContextFailed
        }
        
        context.shouldDeleteInaccessibleFaults = true
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }
    
    // MARK: Persistent coordinator creation
    
    private func createPersistentStoreContainer() throws -> NSPersistentContainer {
        guard
            let url = self.bundle.url(forResource: self.dbName, withExtension: Constants.dbExtension),
            let model = NSManagedObjectModel(contentsOf: url)
        else {
            throw CoreDataStackError.persistentContainerInitFailed
        }
        
        return NSPersistentContainer(name: self.dbName, managedObjectModel: model)
    }
}
