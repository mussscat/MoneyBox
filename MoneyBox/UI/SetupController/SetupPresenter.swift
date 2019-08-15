//
//  SetupPresenter.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage

class SetupPresenter: SetupInput {
    
    private let coreDataStack: ICoreDataStack
    private let storage: IStorage
    weak var viewController: SetupOutput?
    
    init(coreDataStack: ICoreDataStack, storage: IStorage) {
        self.coreDataStack = coreDataStack
        self.storage = storage
    }
    
    func setupPresenter() {
        self.viewController?.showProgress()
        self.coreDataStack.setupStack { result in
            self.viewController?.hideProgress()
            
            result.withValue({ _ in
                self.viewController?.updateWithSetupFinished()
//                self.preloadDataIfNeeded()
            }, errorHandler: { error in
                self.viewController?.showRetriableError(error)
            })
        }
    }
    
    func preloadDataIfNeeded() {
        self.viewController?.updateWithSetupFinished()
    }
}
