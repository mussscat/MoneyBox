//
//  OnboardingCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class OnboardingCoordinator: FlowCoordinator {
    
    private let assembly: OnboardingAssembly
    
    init(assembly: OnboardingAssembly) {
        self.assembly = assembly
    }
    
    private lazy var navigationController = MoneyBoxNavigationController(rootViewController: self.rootViewController)
    
    override var initialViewController: UIViewController? {
        return self.navigationController
    }
    
    private lazy var rootViewController: ShortGoalInformationInputViewController = {
        let controller = self.assembly.shortGoalInfoController()
        controller.onContinue = { [weak self] model in
            self?.showCalculationController(withShortModel: model)
        }
        
        return controller
    }()
    
    private func showCalculationController(withShortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel) {
        let controller = self.assembly.calculationController(shortModel: withShortModel)
        controller.onGoalCreationFinished = { [weak self] in
            self?.finishFlowWithSuccess(true)
        }
        self.navigationController.pushViewController(controller, animated: true)
    }
}
