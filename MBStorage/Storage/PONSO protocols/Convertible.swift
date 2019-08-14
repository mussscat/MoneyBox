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
    
    func updateDatabaseObject(_ object: DBObjectType)
    static func createPonso(from object: DBObjectType) -> Self?
}