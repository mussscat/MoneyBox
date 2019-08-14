//
//  Convertible.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

public typealias PlainObject = Convertible & Identifiable

public protocol Convertible {
    associatedtype DBObjectType: NSManagedObject
    
    func updateManagedObject(_ object: DBObjectType, in context: NSManagedObjectContext)
    func createManagedObject(in context: NSManagedObjectContext) -> DBObjectType?
    static func createPlainObject(from object: DBObjectType) -> Self
}
