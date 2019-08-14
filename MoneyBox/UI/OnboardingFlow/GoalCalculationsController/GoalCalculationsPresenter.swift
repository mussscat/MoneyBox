//
//  GoalCalculationsPresenter.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 29/12/2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import MBStorage

class GoalCalculationsPresenter: IGoalCalculationsInput {
    
    private let storage: IStorage
    private let shortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel
    
    weak var calculationsController: IGoalCalculationsOutput?
    var categories = [GoalsCategoryPlainObject]()
    
    init(storage: IStorage, shortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel) {
        self.storage = storage
        self.shortModel = shortModel
    }
    
    var categoriesNumber: Int {
        return categories.count
    }
    
    func prepareCategoriesList(completion: @escaping (Error?) -> Void) {
        let storageRequest = StorageRequest<GoalsCategoryPlainObject>()
        self.storage.fetch(request: storageRequest) { result in
            result.withValue({ categories in
                self.categories = categories
                self.calculationsController?.updateWithCategories(categories)
                completion(nil)
            }, errorHandler: { error in
                completion(GoalCalculationsPresenterError.couldNotLoadCategoriesList)
            })
        }
    }
    
    func saveGoalWithCalculationsModel(_ model: GoalCalculationsViewController.GoalCalculationsModel) {
        
    }
}
