//
//  NSManagedObjectContext+Rollback.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 29/12/2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func recursiveRollback() {
        self.performAndWait {
            self.rollback()
        }
        if let parentContext = self.parent {
            parentContext.recursiveRollback()
        }
    }
}
