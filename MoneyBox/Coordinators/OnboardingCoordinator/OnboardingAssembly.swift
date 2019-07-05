//
//  OnboardingAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi

class OnboardingAssembly: Assembly {
    private lazy var serviceAssembly: ServicesAssembly = self.context.assembly()
    private lazy var storageAssembly: StorageAssembly = self.context.assembly()
    
    func coordinator() -> OnboardingCoordinator {
        return define(scope: .prototype, init: OnboardingCoordinator(assembly: self))
    }
    
    func shortGoalInfoController() -> ShortGoalInformationInputViewController {
        return define(scope: .prototype, init: ShortGoalInformationInputViewController())
    }
    
    func calculationController(shortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel) -> GoalCalculationsViewController {
        let presenter = self.calculationsControllerPreseter(shortModel: shortModel)
        return define(scope: .prototype, init: GoalCalculationsViewController(presenter: presenter)) {
            presenter.calculationsController = $0
            
            return $0
        }
    }
    
    private func calculationsControllerPreseter(shortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel) -> GoalCalculationsPresenter {
        return define(scope: .prototype, init: GoalCalculationsPresenter(storage: self.storageAssembly.storage,
                                                                         shortModel: shortModel))
    }
}
