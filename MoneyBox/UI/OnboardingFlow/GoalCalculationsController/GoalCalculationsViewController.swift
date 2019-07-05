//
//  GoalCalculationsViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit
import TagListView

class GoalCalculationsViewController: UIViewController, UITextFieldDelegate, IGoalCalculationsOutput, TagListViewDelegate {
    
    struct GoalCalculationsModel {
        var category: SavingsGoalCategory
        var deadline: Date
        var period: Int
    }
    
    @IBOutlet weak var categoryInputTextField: UITextField!
    @IBOutlet weak var deadlineInputTextField: UITextField!
    @IBOutlet weak var periodInputTextField: UITextField!
    @IBOutlet weak var categoryTagsCloudView: TagListView!
    @IBOutlet weak var doneButton: UIButton!
    
    var onGoalCreationFinished: (() -> Void)?
    
    private let presenter: IGoalCalculationsInput
    
    init(presenter: IGoalCalculationsInput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoryInputTextField.delegate = self
        self.deadlineInputTextField.delegate = self
        self.periodInputTextField.delegate = self
        self.categoryTagsCloudView.delegate = self
        
        let dismissalRecognizer = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        self.view.addGestureRecognizer(dismissalRecognizer)
        
        self.doneButton.addTarget(self, action: #selector(submitFormButtonPressed), for: .touchUpInside)
        
        self.preloadCategoriesList()
        
        self.deadlineInputTextField.text = String(describing: Date())
    }
    
    private func preloadCategoriesList() {
        if self.presenter.categoriesNumber == 0 {
            self.showProgress()
            self.presenter.prepareCategoriesList { [weak self] error in
                self?.hideProgress()
                
                if let error = error {
                    self?.showAlertView(error: error)
                }
            }
        }
    }
    
    func updateWithCategories(_ categories: [SavingsGoalCategory]) {
        let tags = categories.reduce(into: [String]()) { result, category in
            result.append(category.name)
        }
        
        self.categoryTagsCloudView.addTags(tags)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc private func mainViewTapped() {
        self.view.endEditing(true)
    }
    
    @objc private func submitFormButtonPressed() {
        guard
            let name = self.categoryInputTextField.text,
//            let dateString = self.deadlineInputTextField.text,
            let period = self.periodInputTextField.text,
            let intPeriod = Int(period)
        else {
            return
        }
        
        let category = SavingsGoalCategory(identifier: "1", name: name, iconURL: "", sortOrder: 1)
        let model = GoalCalculationsModel(category: category, deadline: Date(), period: intPeriod)
        
        self.presenter.saveGoalWithCalculationsModel(model)
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.categoryInputTextField.text = title
        self.view.endEditing(true)
    }
    
    func updateWithSavingsGoal() {
        self.onGoalCreationFinished?()
    }
}
