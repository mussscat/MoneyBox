//
//  ApplicationCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 23.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: FlowCoordinator {
    /*INJECTED*/ var window: UIWindow!
    /*INJECTED*/ var goalsService: ISavingsGoalService!
    /*INJECTED*/ var userDefaults: UserDefaults!
    /*INJECTED*/ weak var assembly: ApplicationAssembly!
    
    // MARK: - FlowCoordinator
    
    override func start() {
        self.window.makeKeyAndVisible()
        self.setupApplicationSettings()
    }
    
    // MARK: - Private
    
    private func setupApplicationSettings() {
        let setupCoordinator = self.assembly.setupCoordinator()
        setupCoordinator.onSuccess = { [weak self, weak setupCoordinator] in
            self?.removeDependency(setupCoordinator)
            self?.showGoalsList()
        }
        
        self.startFlowCoordinator(setupCoordinator)
    }
    
    private func showOnboarding() {
        let onboardingCoordinator = self.assembly.onboardingCoordinator()
        onboardingCoordinator.onSuccess = { [weak self, weak onboardingCoordinator] in
            self?.userDefaults.set(true, forKey: GlobalConstants.userDefaultsKeys.onboardingHasBeenShown.rawValue)
            self?.removeDependency(onboardingCoordinator)
            self?.showGoalsList()
        }
        
        self.startFlowCoordinator(onboardingCoordinator)
    }
    
    private func showGoalsList() {
        let goalsListCoordinator = self.assembly.goalsListCoordinator()
        self.startFlowCoordinator(goalsListCoordinator)
    }
    
    private func hasOnboardingBeenShown() -> Bool {
        return self.userDefaults.bool(forKey: GlobalConstants.userDefaultsKeys.onboardingHasBeenShown.rawValue)
    }
    
    override func startFlowCoordinator(_ coordinator: FlowCoordinator, completion: (() -> Void)? = nil) {
        self.window.rootViewController = coordinator.initialViewController
        self.addDependency(coordinator)
        coordinator.start()
        completion?()
    }
}
