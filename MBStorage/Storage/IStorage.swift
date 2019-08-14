//
//  Storage_protocol.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

public enum StorageError: Error {
    case objectAlreadyExist
    case objectNotFound
    case invalidDatabaseObject
    case failedToCreatePlainObject
    case failedToCreateManagedObject
    
    case saveOrUpdateFailed
    case updateObjectsFailed
    case removeObjectsFailed
    case fetchObjectsFailed
    case saveObjectsFailed
    case countObjectsFailed
    case saveObjectsSynchronouslyFailed
    case removeObjectsSynchronouslyFailed
    
    public var description: String {
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
        default: return String(describing: self)
        }
    }
}

public protocol IStorage {
    //saveOrUpdate -> upsert
    func saveOrUpdate<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void)
    func update<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void)
    func remove<T: PlainObject>(objects: [T], completion: @escaping (Result<Void, Error>) -> Void)
    func fetch<T: PlainObject>(request: StorageRequest<T>, completion: @escaping (Result<[T], Error>) -> Void)
    func count<T: PlainObject>(for request: StorageRequest<T>) throws -> Int
    func save<T: PlainObject>(objects: [T], completion: @escaping (Result<[T], Error>) -> Void)
    
    func saveSynchronously<T: PlainObject>(objects: [T]) throws -> [T]
    func removeSynchronously<T: PlainObject>(objects: [T]) throws
}
