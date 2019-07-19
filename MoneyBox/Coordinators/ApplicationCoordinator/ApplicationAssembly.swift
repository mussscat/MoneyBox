//
//  ApplicationAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 24.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit
import EasyDi

class ApplicationAssembly: Assembly {
    
    private lazy var goalsListAssembly: GoalsAssembly = self.context.assembly()
    private lazy var onboardingAssembly: OnboardingAssembly = self.context.assembly()
    private lazy var servicesAssembly: ServicesAssembly = self.context.assembly()
    private lazy var setupCoordinatorAssembly: SetupCoordinatorAssembly = self.context.assembly()
    
    private var window: UIWindow {
        return define(init: UIWindow(frame: UIScreen.main.bounds))
    }
    
    private func coordinator() -> ApplicationCoordinator {
        return define(scope: .prototype, init: ApplicationCoordinator()) {
            $0.window = self.window
            $0.goalsService = self.servicesAssembly.savingsGoalService
            $0.userDefaults = UserDefaults.standard
            $0.assembly = self
            
            return $0
        }
    }
    
    func setupCoordinator() -> SetupCoordinator {
        return self.setupCoordinatorAssembly.coordinator()
    }
    
    func onboardingCoordinator() -> OnboardingCoordinator {
        return self.onboardingAssembly.coordinator()
    }
    
    func goalsListCoordinator() -> GoalsCoordinator {
        return self.goalsListAssembly.coordinator()
    }
    
    func inject(into delegate: AppDelegate) {
        delegate.window = self.window
        delegate.applicationCoordinator = self.coordinator()
    }
}
