//
//  StorageRequest.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

class StorageRequest<T: PlainObject> {
    var predicate: NSPredicate?
    var sortDescriptors: [NSSortDescriptor]?
    var objectsLimit: Int = 0
    
    init() { }
    
    init(identifier: T.Identifier) {
        self.predicate = NSPredicate(format: "identifier = %@",
                                     argumentArray: [identifier])
        self.objectsLimit = 1
    }
    
    func createFetchRequest() -> NSFetchRequest<T.DBObjectType> {
        let request = NSFetchRequest<T.DBObjectType>(entityName: "\(T.DBObjectType.self)")
        request.sortDescriptors = self.sortDescriptors
        request.predicate = self.predicate
        request.fetchLimit = self.objectsLimit
        
        return request
    }
}
