//
//  Storage.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

class Storage: IStorage {
    
    private let stack: ICoreDataStack
    
    init(coreDataStack: ICoreDataStack) {
        self.stack = coreDataStack
    }
    
    // MARK: IStorage protocol implementation
    
    func saveOrUpdate<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            var savedObjects = [T]()
            savedObjects.reserveCapacity(objects.count)
            
            for object in objects {
                let fetchRequest = StorageRequest<T>(identifier: object.identifier).createFetchRequest()
                let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                if let foundObject = fetchedObjects.first {
                    object.updateDatabaseObject(foundObject)
                    guard let newPlainObject = T.createPonso(from: foundObject) else {
                        throw StorageError.failedToCreatePlainObject
                    }
                    
                    savedObjects.append(newPlainObject)
                } else {
                    guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.DBObjectType.self),
                                                                               into: context) as? T.DBObjectType else {
                        throw StorageError.failedToCreateManagedObject
                    }
                    
                    object.updateDatabaseObject(managedObject)
                    
                    guard let newPlainObject = T.createPonso(from: managedObject) else {
                        throw StorageError.failedToCreatePlainObject
                    }
                    
                    savedObjects.append(newPlainObject)
                }
            }
            
            return savedObjects
        }, completion: { (result: Result<[T], Error>) in
            do {
                let plainObjects = try result.get()
                completion(.success(plainObjects))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    func update<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            var updateResults = [T]()
            updateResults.reserveCapacity(objects.count)
            
            for ponso in objects {
                let fetchRequest = StorageRequest<T>(identifier: ponso.identifier).createFetchRequest()
                let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                if let foundObject = fetchedObjects.first {
                    ponso.updateDatabaseObject(foundObject)
                    guard let plainObject = T.createPonso(from: foundObject) else {
                        throw StorageError.failedToCreatePlainObject
                    }
                    
                    updateResults.append(plainObject)
                } else {
                    throw StorageError.updateObjectsFailed
                }
            }
            
            return updateResults
        }, completion: { (result: Result<[T], Error>) in
            do {
                let objects = try result.get()
                completion(.success(objects))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    func remove<T: PlainObject>(objects: [T], completion: @escaping (Result<Void, Error>) -> Void) {
        self.stack.execute(transaction: { context in
            let identifiers = objects.map({ $0.identifier })
            let request = StorageRequest<T>()
            request.predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
            let fetchedObjects = try self.stack.execute(request.createFetchRequest(), context: context)
            fetchedObjects.forEach {
                context.delete($0)
            }
        }, completion: { (result: Result<Void, Error>) in
            do {
                try result.get()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    func fetch<T: PlainObject>(request: StorageRequest<T>, completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            let objects = try self.stack.execute(request.createFetchRequest(), context: context)
            let ponsoObjects = objects.map({ T.createPonso(from: $0) }).compactMap { $0 }
            return ponsoObjects
        }, completion: completion)
    }
}
