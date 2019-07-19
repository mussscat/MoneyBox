//
//  GoalsAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi

class GoalsAssembly: Assembly {
    private lazy var servicesAssembly: ServicesAssembly = self.context.assembly()
    private lazy var storageAssembly: StorageAssembly = self.context.assembly()
    private lazy var onboardingAssembly: OnboardingAssembly = self.context.assembly()
    
    func coordinator() -> GoalsCoordinator {
        return define(scope: .prototype, init: GoalsCoordinator(assembly: self))
    }
    
    func goalsViewController() -> GoalsViewController {
        let presenter = self.goalsPresenter()
        return define(scope: .prototype, init: GoalsViewController(presenter: presenter)) {
            presenter.view = $0
            return $0
        }
    }
    
    private func goalsPresenter() -> GoalsPresenter {
        return define(scope: .prototype, init: GoalsPresenter(goalsService: self.servicesAssembly.savingsGoalService,
                                                              storage: self.storageAssembly.storage))
    }
}
