//
//  GoalsListCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class GoalsListCoordinator: FlowCoordinator {
    
    private let assembly: GoalsListAssembly
    
    init(assembly: GoalsListAssembly) {
        self.assembly = assembly
    }
    
    private lazy var navigationController = MoneyBoxNavigationCrontroller(rootViewController: self.rootViewController)
    
    override var initialViewController: UIViewController? {
        return self.navigationController
    }
    
    private lazy var rootViewController: GoalsListViewController = {
        let controller = self.assembly.goalsListViewController()
        
        return controller
    }()
}
