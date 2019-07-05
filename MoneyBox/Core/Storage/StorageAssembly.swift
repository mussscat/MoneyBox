//
//  StorageAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi

class StorageAssembly: Assembly {
    var storage: IStorage {
        return define(scope: .lazySingleton, init: Storage(coreDataStack: self.coreDataStack))
    }
    
    var coreDataStack: ICoreDataStack {
        return define(scope: .lazySingleton, init: CoreDataStack(dbName: "MoneyBox", bundle: Bundle.main))
    }
}
