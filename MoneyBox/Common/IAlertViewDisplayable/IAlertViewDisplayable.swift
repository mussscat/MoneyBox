//
//  IAlertViewDisplayable.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

protocol IAlertViewDisplayable {
    func showAlertView(text: String?, title: String?, completion: (() -> Void)?)
    func showAlertView(error: Error, completion: (() -> Void)?)
}

extension IAlertViewDisplayable {
    func showAlertView(text: String?, title: String? = nil, completion: (() -> Void)? = nil) {
        self.showAlertView(text: text, title: title, completion: completion)
    }
    
    func showAlertView(error: Error) {
        self.showAlertView(error: error, completion: nil)
    }
}
