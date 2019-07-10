//
//  ShortGoalInformationInputViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

class ShortGoalInformationInputViewController: UIViewController, UITextFieldDelegate {
    
    struct ShortGoalInfoModel {
        var name: String
        var totalSum: Double
        var currency: Currency
    }
    
    enum ShortGoalFieldTag: Int {
        case name = 0
        case sum = 1
        case currency = 2
    }
    
    var onContinue: ((ShortGoalInfoModel) -> Void)?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var totalSumTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    
    var storage: IStorage!
    private var currency: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.tag = ShortGoalFieldTag.name.rawValue
        self.totalSumTextField.tag = ShortGoalFieldTag.sum.rawValue
        self.currencyTextField.tag = ShortGoalFieldTag.currency.rawValue
        
        self.nameTextField.delegate = self
        self.totalSumTextField.delegate = self
        self.currencyTextField.delegate = self
        
        self.storage.fetch(request: StorageRequest<Currency>()) { result in
            if let currency = try? result.get().first {
                self.currency = currency
                self.currencyTextField.text = currency.name
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        guard
            let name = self.nameTextField.text,
            let sum = self.totalSumTextField.text,
            let doubleSum = Double(sum),
            let continueClosure = self.onContinue
        else {
            return
        }
        
        let currency = self.currency!
        let model = ShortGoalInfoModel(name: name,
                                       totalSum: doubleSum,
                                       currency: currency)
        
        continueClosure(model)
    }
    
    @IBAction func onCreateCurrency(_ sender: Any) {
        let currency = Currency(name: "RUB")
        self.storage.createOrUpdate(objects: [currency]) { result in
            do {
                let fetchedCurrency = try result.get().first
                self.currency = fetchedCurrency
                self.currencyTextField.text = fetchedCurrency?.name
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func onCreateCategory(_ sender: Any) {
        let category = SavingsGoalCategory(name: "Joy", iconURL: nil)
        self.storage.createOrUpdate(objects: [category]) { result in
            do {
                let fetchedCategory = try result.get().first
                print(fetchedCategory)
            } catch {
                print(error)
            }
        }
    }
}
