//
//  GoalCalculationsPresenter.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 29/12/2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

class GoalCalculationsPresenter: IGoalCalculationsInput {
    
    private let storage: IStorage
    private let shortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel
    
    weak var calculationsController: IGoalCalculationsOutput?
    var categories = [SavingsGoalCategory]()
    
    init(storage: IStorage, shortModel: ShortGoalInformationInputViewController.ShortGoalInfoModel) {
        self.storage = storage
        self.shortModel = shortModel
    }
    
    var categoriesNumber: Int {
        return categories.count
    }
    
    func prepareCategoriesList(completion: @escaping (Error?) -> Void) {
        let storageRequest = StorageRequest<SavingsGoalCategory>()
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
        let goal = SavingsGoal(category: model.category,
                               totalAmount: self.shortModel.totalSum,
                               name: self.shortModel.name,
                               currency: self.shortModel.currency,
                               deadline: model.deadline,
                               period: model.period)
        self.calculationsController?.showProgress()
        self.storage.createOrUpdate(objects: [goal]) { result in
            self.calculationsController?.hideProgress()
            result.withValue({ _ in
                self.calculationsController?.updateWithSavingsGoal()
            }, errorHandler: { error in
                self.calculationsController?.showAlertView(error: error)
            })
        }
    }
}
