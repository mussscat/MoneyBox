//
//  SetupPresenter.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation

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
        let path = Bundle.main.path(forResource: "DefaultCategories", ofType: "plist")!
        let dict = NSDictionary(contentsOfFile: path)
        guard let categories = dict?.object(forKey: "Categories") as? [String] else {
            return
        }
        
        let plainObjects = categories.reduce(into: [SavingsGoalCategory]()) { result, category in
            let object = SavingsGoalCategory(identifier: category, name: category, iconURL: "", sortOrder: 1)
            result.append(object)
        }
        
        self.viewController?.showProgress()
        self.storage.saveOrUpdate(objects: plainObjects) { result in
            self.viewController?.hideProgress()
            result.withValue({ _ in
                self.viewController?.updateWithSetupFinished()
            }, errorHandler: { error in
                self.viewController?.showRetriableError(error)
            })
        }
    }
}
