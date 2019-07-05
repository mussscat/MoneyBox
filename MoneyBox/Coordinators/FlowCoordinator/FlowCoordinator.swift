//
//  FlowCoordinator.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 23.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class FlowCoordinator {
    private var onFlowFinished: (() -> Void)?
    private var childCoordinators: [FlowCoordinator] = []
    
    /// Override it to support automatic flow start by using `startFlowCoordinator()` func
    var initialViewController: UIViewController? {
        return nil
    }
    
    func start() {
        print("\(String(describing: self.self)) started")
    }
    
    /**
     Starts flow coordinator from current coordinator.
     If both coordinators provide `initialViewController`, presentation and dismissal will be handled by `FlowCoordinator`.
     Don't forget to call `finishFlowWithSuccess()` when flow should be finished.
     
     - Parameter coordinator: The coordinator to start.
     - Parameter completion: Block that is called after presentation finishes.
     - Note: Each flow must be started by modal presentation and should use navigation stack inside.
     Otherwise you should handle presentation and dismissal by yourself.
     */
    func startFlowCoordinator(_ coordinator: FlowCoordinator, completion: (() -> Void)? = nil) {
        coordinator.onFlowFinished = { [weak self, weak coordinator] in
            guard let `self` = self, let coordinator = coordinator else {
                assertionFailure()
                return
            }
            if let initialViewController = self.initialViewController, coordinator.initialViewController != nil {
                initialViewController.dismiss(animated: true) {
                    self.removeDependency(coordinator)
                }
            } else {
                self.removeDependency(coordinator)
            }
        }
        if let initialViewControllerToPresent = coordinator.initialViewController {
            guard let initialViewController = self.initialViewController else {
                assertionFailure("Impossible to start flow when self.initialViewController is not set")
                return
            }
            initialViewController.present(initialViewControllerToPresent, animated: true) {
                coordinator.start()
                self.addDependency(coordinator)
                completion?()
            }
        } else {
            coordinator.start()
            self.addDependency(coordinator)
            completion?()
        }
    }
    
    func addDependency(_ coordinator: FlowCoordinator) {
        if (!self.childCoordinators.contains { $0 === coordinator }) {
            self.childCoordinators.append(coordinator)
            
            print("\(String(describing: self.self)) added dependency to \(String(describing: coordinator.self))")
        }
    }
    
    func removeDependency(_ coordinator: FlowCoordinator?) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
            
            print("\(String(describing: self.self)) removed dependency to \(String(describing: coordinator.self))")
        }
    }
    
    func dismissDependantCoordinators(completion: @escaping () -> Void) {
        let coordinatorNames = self.childCoordinators.map { "\(String(describing: $0.self))" }
        print("Removed dependencies from \(String(describing: self.self)) to \(coordinatorNames)")
        if self.initialViewController?.presentedViewController != nil {
            self.initialViewController?.dismiss(animated: false) {
                self.childCoordinators.removeAll()
                completion()
            }
        } else {
            self.childCoordinators.removeAll()
            completion()
        }
    }
    
    /// Call it when flow is completed. If you provide `initialViewController`, flow will be dismissed by FlowCoordinator.
    func finishFlowWithSuccess(_: Bool) {
        self.onFlowFinished?()
    }
}

