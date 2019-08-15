//
//  GoalCalculationsIO.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation

public enum GoalCalculationsPresenterError: Error {
    case couldNotLoadCategoriesList
}

protocol IGoalCalculationsOutput: AnyObject, IProgressDisplayable, AlertViewDisplayable {
    func updateWithCategories(_ categories: [GoalCategory])
    func updateWithSavingsGoal()
}

protocol IGoalCalculationsInput {
    func prepareCategoriesList(completion: @escaping (Error?) -> Void)
    func saveGoalWithCalculationsModel(_ model: GoalCalculationsViewController.GoalCalculationsModel)
    var categoriesNumber: Int { get }
}
