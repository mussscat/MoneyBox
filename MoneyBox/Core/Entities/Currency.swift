//
//  Currency.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 18.12.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage

public struct Currency: Identifiable, Codable {
    public var identifier: String
    public var name: String
    
    init(identifier: String,
         name: String) {
        self.identifier = identifier
        self.name = name
    }
}

extension Currency: Convertible {
    public typealias DBObjectType = CurrencyDBO
    
    public func updateDatabaseObject(_ object: DBObjectType) {
        object.name = self.name
        object.identifier = self.identifier
    }
    
    public static func createPonso(from object: DBObjectType) -> Currency? {
        guard
            let identifier = object.identifier,
            let name = object.name
        else {
            return nil
        }
        
        return Currency(identifier: identifier,
                        name: name)
    }
}
