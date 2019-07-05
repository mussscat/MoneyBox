//
//  SetupCoordinatorAssembly.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 06.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import EasyDi

class SetupCoordinatorAssembly: Assembly {
    
    private lazy var storageAssembly: StorageAssembly = self.context.assembly()
    
    func coordinator() -> SetupCoordinator {
        return define(scope: .prototype, init: SetupCoordinator(assembly: self))
    }
    
    func setupViewController() -> SetupViewController {
        let presenter = self.presenter()
        return define(scope: .prototype, init: SetupViewController(presenter: presenter)) {
            presenter.viewController = $0
            
            return $0
        }
    }
    
    func presenter() -> SetupPresenter {
        return define(scope: .prototype, init: SetupPresenter(coreDataStack: self.storageAssembly.coreDataStack,
                                                              storage: self.storageAssembly.storage))
    }
}
