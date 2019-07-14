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
    
    func createOrUpdate<T: PlainObject>(objects: [T], completion: @escaping (Swift.Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            var savedObjects = [T]()
            savedObjects.reserveCapacity(objects.count)
            
            for object in objects {
                let fetchRequest = StorageRequest<T>(identifier: object.identifier).createFetchRequest()
                let fetchedObjects = try? self.stack.execute(fetchRequest, context: context)
                if let foundObject = fetchedObjects?.first {
                    object.updateManagedObject(foundObject, in: context)
                    let newPlainObject = T.createPlainObject(from: foundObject)
                    savedObjects.append(newPlainObject)
                } else {
                    guard let managedObject = object.createManagedObject(in: context) else {
                        throw StorageError.failedToCreateManagedObject
                    }
                    
                    let newPlainObject = T.createPlainObject(from: managedObject)
                    savedObjects.append(newPlainObject)
                }
            }
            
            return savedObjects
        }, completion: { (result: Swift.Result<[T], Error>) in
            do {
                let plainObjects = try result.get()
                completion(.success(plainObjects))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    func update<T: PlainObject>(objects: [T], completion: @escaping (Swift.Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            var updateResults = [T]()
            updateResults.reserveCapacity(objects.count)
            
            for object in objects {
                let fetchRequest = StorageRequest<T>(identifier: object.identifier).createFetchRequest()
                let fetchedObjects = try self.stack.execute(fetchRequest, context: context)
                if let foundObject = fetchedObjects.first {
                    object.updateManagedObject(foundObject, in: context)
                    let plainObject = T.createPlainObject(from: foundObject)
                    updateResults.append(plainObject)
                } else {
                    throw StorageError.updateObjectsFailed
                }
            }
            
            return updateResults
        }, completion: { (result: Swift.Result<[T], Error>) in
            do {
                let objects = try result.get()
                completion(.success(objects))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    func remove<T: PlainObject>(objects: [T], completion: @escaping (Swift.Result<Void, Error>) -> Void) {
        self.stack.execute(transaction: { context in
            let identifiers = objects.map({ $0.identifier })
            let request = StorageRequest<T>()
            request.predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
            let fetchedObjects = try self.stack.execute(request.createFetchRequest(), context: context)
            fetchedObjects.forEach {
                context.delete($0)
            }
        }, completion: { (result: Swift.Result<Void, Error>) in
            do {
                try result.get()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        })
    }
    
    func fetch<T: PlainObject>(request: StorageRequest<T>, completion: @escaping (Swift.Result<[T], Error>) -> Void) {
        self.stack.execute(transaction: { context in
            let objects = try self.stack.execute(request.createFetchRequest(), context: context)
            let plainObjects = objects.map({ T.createPlainObject(from: $0) }).compactMap { $0 }
            return plainObjects
        }, completion: completion)
    }
    
    func fetchObject<T: PlainObject>(with id: T.Identifier,
                                     completion: @escaping (Swift.Result<T, StorageError>) -> Void) {
        let request = StorageRequest<T>(identifier: id)
        self.fetchObject(with: request, completion: completion)
    }
    
    func fetchObject<T: PlainObject>(with request: StorageRequest<T>, completion: @escaping (Swift.Result<T, StorageError>) -> Void) {
        let singleRequest = request
        singleRequest.objectsLimit = 1
        self.fetch(request: singleRequest) { result in
            do {
                let objects = try result.get()
                guard let object = objects.first else {
                    throw StorageError.objectNotFound
                }
                
                completion(.success(object))
            } catch {
                completion(.failure(StorageError.fetchObjectFailed))
            }
        }
    }
}
