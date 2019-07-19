//
//  GoalsCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class GoalsCoordinator: FlowCoordinator {
    
    private let assembly: GoalsListAssembly
    
    init(assembly: GoalsListAssembly) {
        self.assembly = assembly
    }
    
    private lazy var navigationController = MoneyBoxNavigationCrontroller(rootViewController: self.rootViewController)
    
    override var initialViewController: UIViewController? {
        return self.navigationController
    }
    
    private lazy var rootViewController: GoalsViewController = {
        let controller = self.assembly.goalsViewController()
        controller.onAddGoal = { [weak self] in
            self?.startAddGoalFlow()
        }
        return controller
    }()
    
    private func startAddGoalFlow() {
        let coordinator = self.assembly.onboardingCoordinator()
        coordinator.onSuccess = { [weak self] in
            self?.rootViewController.updateWithContainersLoaded()
        }
        self.startFlowCoordinator(coordinator)
    }
}
