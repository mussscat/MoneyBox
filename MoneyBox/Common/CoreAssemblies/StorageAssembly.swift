//
//  StorageAssembly.swift
//  MoneyBox
//
//  Created by s.m.fedorov on 13/08/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi
import MBStorage

class StorageAssembly: Assembly {
    var storage: IStorage {
        return define(scope: .lazySingleton, init: Storage(coreDataStack: self.coreDataStack))
    }
    
    var coreDataStack: ICoreDataStack {
        return define(scope: .lazySingleton, init: CoreDataStack(dbName: "MoneyBox.momd", bundle: Bundle.main))
    }
}
