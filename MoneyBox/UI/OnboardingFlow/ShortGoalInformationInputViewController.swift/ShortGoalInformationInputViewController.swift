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
        var currency: String
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameTextField.tag = ShortGoalFieldTag.name.rawValue
        self.totalSumTextField.tag = ShortGoalFieldTag.sum.rawValue
        self.currencyTextField.tag = ShortGoalFieldTag.currency.rawValue
        
        self.nameTextField.delegate = self
        self.totalSumTextField.delegate = self
        self.currencyTextField.delegate = self
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
            let currency = self.currencyTextField.text,
            let continueClosure = self.onContinue
        else {
            return
        }
        
        let model = ShortGoalInfoModel(name: name,
                                       totalSum: doubleSum,
                                       currency: currency)
        
        continueClosure(model)
    }
}
