//
//  CoreDataStack.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

typealias CoreDataStackTransaction<T> = ((NSManagedObjectContext) throws -> T)

enum CoreDataStackError: Error {
    case gettingMainContextFailed
    case gettingBackgroundContextFailed
    case persistentContainerInitFailed
    case setupStackFailed
    case executeFetchRequestFailed
    case executeAsyncTransactionFailed
    case executeSyncTransactionFailed
    case unsafeExecuteSyncTransactionFailed
    
    var localizedDescription: String {
        switch self {
        case .executeFetchRequestFailed:
            return "Faield to execute fetch request"
        default:
            return "Failure happened: \(String(describing: self))"
        }
    }
}

protocol ICoreDataStack {
    func execute<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) throws -> [T]
    func execute<T>(transaction: @escaping ((NSManagedObjectContext) throws -> T), completion: @escaping ((Result<T, Error>) -> Void))
    func setupStack(completion: ((Result<Void, Error>) -> Void)?)
}
