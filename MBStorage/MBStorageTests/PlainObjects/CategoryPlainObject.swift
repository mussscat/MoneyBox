//
//  CategoryPlainObject.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
@testable import MBStorage

struct CategoryPlainObject: PlainObject {
    typealias Identifier = String
    typealias DBObjectType = CategoryEntity
    
    var identifier: Identifier
    var name: String
    
    func updateDatabaseObject(_ object: CategoryEntity) {
        object.identifier = self.identifier
        object.name = self.name
    }
    
    static func createPonso(from object: CategoryEntity) -> CategoryPlainObject? {
        guard let identifier = object.identifier, let name = object.name else {
            return nil
        }
        
        return CategoryPlainObject(identifier: identifier, name: name)
    }
}
