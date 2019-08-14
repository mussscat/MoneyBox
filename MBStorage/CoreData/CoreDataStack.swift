//
//  CoreDataStack.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack: ICoreDataStack {
    
    private enum Constants {
        static let dbExtension = "momd"
    }
    
    private var persistentStoreContainer: NSPersistentContainer?
    
    private let dbName: String
    private let bundle: Bundle
    private let storeType: String
    
    public init(dbName: String, bundle: Bundle, storeType: String = NSSQLiteStoreType) {
        self.dbName = dbName
        self.bundle = bundle
        self.storeType = storeType
    }
    
    // MARK: CoreDataStack protocol implementation
    
    public func execute<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) throws -> [T] {
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            throw CoreDataStackError.executeFetchRequestFailed
        }
    }
    
    public func execute<T>(transaction: @escaping ((NSManagedObjectContext) throws -> T), completion: @escaping ((Result<T, Error>) -> Void)) {
        let result = self.executeSyncTransaction(transaction)
        switch result {
        case let .success(value):
            completion(.success(value))
        case .failure:
            completion(.failure(CoreDataStackError.executeAsyncTransactionFailed))
        }
    }
    
    public func executeSync<T>(_ transaction: @escaping (NSManagedObjectContext) throws -> T) throws -> T {
        let result = self.executeSyncTransaction(transaction)
        switch result {
        case let .success(value): return value
        case .failure: throw CoreDataStackError.executeSyncFailed
        }
    }
    
    public func executeSyncTransaction<T>(_ transaction: @escaping (NSManagedObjectContext) throws -> T) -> Result<T, Error> {
        do {
            let context = try self.getBackgroundContext()
            var result = Result<T, Error>.failure(CoreDataStackError.executeSyncTransactionFailed)
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
            return .failure(CoreDataStackError.executeSyncTransactionFailed)
        }
    }
    
    public func setupStack(completion: ((Result<Void, Error>) -> Void)?) {
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
        
        let container = NSPersistentContainer(name: self.dbName, managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = self.storeType
        container.persistentStoreDescriptions = [description]
        
        return container
    }
}
