//
//  GoalsListAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi

class GoalsListAssembly: Assembly {
    private lazy var servicesAssembly: ServicesAssembly = self.context.assembly()
    
    func coordinator() -> GoalsListCoordinator {
        return define(scope: .prototype, init: GoalsListCoordinator(assembly: self))
    }
    
    func goalsListViewController() -> GoalsListViewController {
        return define(scope: .prototype, init: GoalsListViewController(goalsService: self.servicesAssembly.savingsGoalService))
    }
}
