//
//  Storage.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

public class Storage: IStorage {
    
    private let stack: ICoreDataStack
    
    public init(coreDataStack: ICoreDataStack) {
        self.stack = coreDataStack
    }
    
    // MARK: IStorage protocol implementation
    
    public func saveOrUpdate<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            var savedObjects = [T]()
            savedObjects.reserveCapacity(objects.count)
            
            for object in objects {
                let fetchRequest = StorageRequest<T>(identifier: object.identifier).fetchRequest()
                let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                if let foundObject = fetchedObjects.first {
                    object.updateManagedObject(foundObject, in: context)
                    guard let newPlainObject = T.createPlainObject(from: foundObject) else {
                        throw StorageError.failedToCreatePlainObject
                    }
                    
                    savedObjects.append(newPlainObject)
                } else {
                    guard let managedObject = object.createManagedObject(in: context) else {
                        throw StorageError.failedToCreateManagedObject
                    }
                    
                    guard let newPlainObject = T.createPlainObject(from: managedObject) else {
                        throw StorageError.failedToCreatePlainObject
                    }
                    
                    savedObjects.append(newPlainObject)
                }
            }
            
            return savedObjects
        }, completion: { (result: Result<[T], Error>) in
            do {
                let plainObjects = try result.get()
                
                DispatchQueue.main.async {
                    completion(.success(plainObjects))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StorageError.saveOrUpdateFailed))
                }
            }
        })
    }
    
    public func update<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            var updateResults = [T]()
            updateResults.reserveCapacity(objects.count)
            
            for object in objects {
                let fetchRequest = StorageRequest<T>(identifier: object.identifier).fetchRequest()
                let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                
                guard let foundObject = fetchedObjects.first else {
                    throw StorageError.objectNotFound
                }
                
                object.updateManagedObject(foundObject, in: context)
                guard let plainObject = T.createPlainObject(from: foundObject) else {
                    throw StorageError.failedToCreatePlainObject
                }
                
                updateResults.append(plainObject)
            }
            
            return updateResults
        }, completion: { (result: Result<[T], Error>) in
            do {
                let objects = try result.get()
                
                DispatchQueue.main.async {
                    completion(.success(objects))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StorageError.updateObjectsFailed))
                }
            }
        })
    }
    
    public func remove<T: PlainObject>(objects: [T], completion: @escaping (Result<Void, Error>) -> Void) {
        self.stack.execute(transaction: { context in
            let identifiers = objects.map({ $0.identifier })
            let request = StorageRequest<T>(identifiers: identifiers)
            let fetchedObjects = try self.stack.execute(request.fetchRequest(), context: context)
            fetchedObjects.forEach {
                context.delete($0)
            }
        }, completion: { (result: Result<Void, Error>) in
            do {
                try result.get()
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StorageError.removeObjectsFailed))
                }
            }
        })
    }
    
    public func fetch<T: PlainObject>(request: StorageRequest<T>, completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context -> [T] in
            let objects = try self.stack.execute(request.fetchRequest(), context: context)
            let ponsoObjects = objects.map({ T.createPlainObject(from: $0) }).compactMap { $0 }
            return ponsoObjects
        }, completion: { result in
            do {
                let objects = try result.get()
                
                DispatchQueue.main.async {
                    completion(.success(objects))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StorageError.fetchObjectsFailed))
                }
            }
        })
    }
    
    public func count<T: PlainObject>(for request: StorageRequest<T>) throws -> Int {
        do {
            let count = try self.stack.executeSync({ context -> Int in
                return try context.count(for: request.fetchRequest())
            })
            
            return count
        } catch {
            throw StorageError.countObjectsFailed
        }
        
    }
    
    public func save<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context -> [T] in
            var savedObjects = [T]()
            savedObjects.reserveCapacity(objects.count)
            
            for object in objects {
                let fetchRequest = StorageRequest<T>(identifier: object.identifier).fetchRequest()
                let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                guard fetchedObjects.isEmpty else {
                    continue
                }
                
                guard let managedObject = object.createManagedObject(in: context) else {
                    throw StorageError.failedToCreateManagedObject
                }
                
                guard let newPlainObject = T.createPlainObject(from: managedObject) else {
                    throw StorageError.failedToCreatePlainObject
                }
                
                savedObjects.append(newPlainObject)
            }
            
            return savedObjects
        }, completion: { result in
            do {
                let objects = try result.get()
                DispatchQueue.main.async {
                    completion(.success(objects))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(StorageError.saveObjectsFailed))
                }
            }
        })
    }
    
    @discardableResult
    public func saveSynchronously<T: PlainObject>(objects: [T]) throws -> [T] {
        do {
            let returnObjects = try self.stack.executeSync({ context -> [T] in
                var savedObjects = [T]()
                savedObjects.reserveCapacity(objects.count)
                
                for object in objects {
                    let fetchRequest = StorageRequest<T>(identifier: object.identifier).fetchRequest()
                    let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                    guard fetchedObjects.isEmpty else {
                        continue
                    }
                    
                    guard let managedObject = object.createManagedObject(in: context) else {
                        throw StorageError.failedToCreateManagedObject
                    }
                    
                    guard let newPlainObject = T.createPlainObject(from: managedObject) else {
                        throw StorageError.failedToCreatePlainObject
                    }
                    
                    savedObjects.append(newPlainObject)
                }
                
                return savedObjects
            })
            
            return returnObjects
        } catch {
            throw StorageError.saveObjectsSynchronouslyFailed
        }
    }
    
    public func removeSynchronously<T: PlainObject>(objects: [T]) throws {
        do {
            try self.stack.executeSync { context in
                let identifiers = objects.map({ $0.identifier })
                let request = StorageRequest<T>()
                request.predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
                let fetchedObjects = try self.stack.execute(request.fetchRequest(), context: context)
                fetchedObjects.forEach {
                    context.delete($0)
                }
            }
        } catch {
            throw StorageError.removeObjectsSynchronouslyFailed
        }
    }
}
