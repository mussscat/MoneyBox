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
        guard let path = Bundle.main.path(forResource: "DefaultCategories", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) else {
            return
        }
        
        guard let categories = dictionary.object(forKey: "Categories") as? [String] else {
            return
        }
        
        let plainObjects = categories.reduce(into: [SavingsGoalCategory]()) { result, categoryName in
            let object = SavingsGoalCategory(name: categoryName, iconURL: nil)
            result.append(object)
        }
        
        self.viewController?.showProgress()
        self.storage.createOrUpdate(objects: plainObjects) { result in
            self.viewController?.hideProgress()
            result.withValue({ _ in
                self.viewController?.updateWithSetupFinished()
            }, errorHandler: { error in
                self.viewController?.showRetriableError(error)
            })
        }
    }
}
