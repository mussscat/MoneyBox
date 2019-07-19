//
//  IProgressDisplayable.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 29/12/2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import AsyncDisplayKit

protocol IProgressDisplayable {
    func showProgress()
    func hideProgress()
}

extension IProgressDisplayable {
    func showProgress() {
        ProgressManager.shared.showProgress()
    }
    
    func hideProgress() {
        ProgressManager.shared.hideProgress()
    }
}

extension UIWindow: IProgressDisplayable {}
extension ASViewController: IProgressDisplayable {}
