//
//  SetupCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class SetupCoordinator: FlowCoordinator {
    
    private let assembly: SetupCoordinatorAssembly
    
    init(assembly: SetupCoordinatorAssembly) {
        self.assembly = assembly
    }

    private lazy var rootViewController: SetupViewController = {
        let controller = self.assembly.setupViewController()
        controller.onLoadingSucceeded = { [weak self] in
            self?.finishFlowWithSuccess(true)
        }
        return controller
    }()
    
    override var initialViewController: UIViewController? {
        return self.rootViewController
    }
}
