//
//  StorageRequest.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import CoreData

public class StorageRequest<T: PlainObject> {
    public var predicate: NSPredicate?
    public var sortDescriptors: [NSSortDescriptor]?
    public var objectsLimit: Int = 0
    
    public init() { }
    
    public init(identifier: T.Identifier) {
        self.predicate = NSPredicate(format: "identifier = %@",
                                     argumentArray: [identifier])
        self.objectsLimit = 1
    }
    
    public init(identifiers: [T.Identifier]) {
        self.predicate = NSPredicate(format: "identifier IN %@", argumentArray: [identifiers])
        self.objectsLimit = identifiers.count
    }
    
    public func fetchRequest() -> NSFetchRequest<T.DBObjectType> {
        let request = NSFetchRequest<T.DBObjectType>(entityName: "\(T.DBObjectType.self)")
        request.sortDescriptors = self.sortDescriptors
        request.predicate = self.predicate
        request.fetchLimit = self.objectsLimit
        
        return request
    }
}
