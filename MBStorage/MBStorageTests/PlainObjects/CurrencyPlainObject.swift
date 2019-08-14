//
//  CurrencyPlainObject.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import Foundation
@testable import MBStorage

struct CurrencyPlainObject: PlainObject {
    typealias Identifier = String
    typealias DBObjectType = CurrencyEntity
    
    var identifier: Identifier
    var name: String
    
    func updateDatabaseObject(_ object: CurrencyEntity) {
        object.identifier = self.identifier
        object.name = self.name
    }
    
    static func createPonso(from object: CurrencyEntity) -> CurrencyPlainObject? {
        guard let identifier = object.identifier, let name = object.name else {
            return nil
        }
        
        return CurrencyPlainObject(identifier: identifier, name: name)
    }
}
