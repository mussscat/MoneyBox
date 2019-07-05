//
//  UIViewController+IProgressDisplayable.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 29/12/2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController: IProgressDisplayable {
    
    func showProgress() {
        if let navigationController = self.navigationController {
            MBProgressHUD.showAdded(to: navigationController.view, animated: true)
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hideProgress() {
        if let navigationController = self.navigationController {
            MBProgressHUD.hide(for: navigationController.view, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

