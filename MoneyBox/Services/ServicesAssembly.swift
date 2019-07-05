//
//  ServicesAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi

class ServicesAssembly: Assembly {
    
    private lazy var storageAssembly: StorageAssembly = self.context.assembly()
    
    var savingsGoalService: ISavingsGoalService {
        return define(scope: .prototype, init: SavingsGoalService(storage: self.storageAssembly.storage))
    }
}
