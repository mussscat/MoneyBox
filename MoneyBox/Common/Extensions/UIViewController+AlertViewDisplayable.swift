//
//  UIViewController+AlertViewDisplayable.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: AlertViewDisplayable {
    func showAlertView(text: String?, title: String? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: text,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion?()
        }))
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    func showAlertView(error: Error, completion: (() -> Void)? = nil) {
        self.showAlertView(text: error.localizedDescription, completion: completion)
    }
}
