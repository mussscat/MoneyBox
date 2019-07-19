//
//  MoneyBoxNavigationController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class MoneyBoxNavigationController: ASNavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated _: Bool) {
        let backItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.topViewController?.navigationItem.backBarButtonItem = backItem
        
        super.pushViewController(viewController, animated: true)
    }
    
    override var viewControllers: [UIViewController] {
        didSet {
            for controller in self.viewControllers {
                let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                controller.navigationItem.backBarButtonItem = backItem
            }
        }
    }
}
