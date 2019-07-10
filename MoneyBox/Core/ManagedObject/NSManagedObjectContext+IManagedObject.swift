//
//  NSManagedObjectContext+IManagedObject.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 09/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insertNewObject<T: IManagedObject>() -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T
    }
}
