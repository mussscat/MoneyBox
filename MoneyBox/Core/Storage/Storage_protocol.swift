//
//  Storage_protocol.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import PromiseKit

enum StorageError: Error {
    case objectAlreadyExist
    case objectNotFound
    case invalidDatabaseObject
    case failedToCreatePlainObject
    case failedToCreateManagedObject
    case updateObjectsFailed
    case fetchObjectFailed
    
    var description: String {
        switch self {
        case .invalidDatabaseObject:
            return "Invalid database object"
        case .objectAlreadyExist:
            return "Object already exist"
        case .objectNotFound:
            return "Object not found"
        case .failedToCreatePlainObject:
            return "Couldn't create plain object from managedObject"
        case .failedToCreateManagedObject:
            return "Failed create managed object"
        case .updateObjectsFailed:
            return "failed to update objects in storage"
        case .fetchObjectFailed:
            return "failed to fetch single object from storage"
        }
    }
}

protocol IStorage {
    func createOrUpdate<T: PlainObject>(objects: [T], completion: @escaping (Swift.Result<[T], Error>) -> Void)
    func update<T: PlainObject>(objects: [T], completion: @escaping (Swift.Result<[T], Error>) -> Void)
    func remove<T: PlainObject>(objects: [T], completion: @escaping (Swift.Result<Void, Error>) -> Void)
    func fetch<T: PlainObject>(request: StorageRequest<T>, completion: @escaping (Swift.Result<[T], Error>) -> Void)
    func fetchObject<T: PlainObject>(with id: T.Identifier, completion: @escaping (Swift.Result<T, StorageError>) -> Void)
    func fetchObject<T: PlainObject>(with request: StorageRequest<T>, completion: @escaping (Swift.Result<T, StorageError>) -> Void)
}

extension IStorage {
    func fetch<T: PlainObject>(request: StorageRequest<T>) -> Promise<[T]> {
        return Promise<[T]> { resolver in
            self.fetch(request: request, completion: { result in
                do {
                    let objects = try result.get()
                    resolver.fulfill(objects)
                } catch {
                    resolver.reject(error)
                }
            })
        }
    }
    
    func fetchObject<T: PlainObject>(with id: T.Identifier) -> Promise<T> {
        return wrap { self.fetchObject(with: id, completion: $0) }
    }
}
