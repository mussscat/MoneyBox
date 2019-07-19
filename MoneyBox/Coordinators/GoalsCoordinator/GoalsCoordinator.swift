//
//  GoalsCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class GoalsCoordinator: FlowCoordinator {
    
    private let assembly: GoalsAssembly
    
    init(assembly: GoalsAssembly) {
        self.assembly = assembly
    }
    
    private lazy var navigationController = MoneyBoxNavigationController(rootViewController: self.rootViewController)
    
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
        
    }
}
