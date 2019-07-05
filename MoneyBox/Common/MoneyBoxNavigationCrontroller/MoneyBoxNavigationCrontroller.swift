//
//  MoneyBoxNavigationCrontroller.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

class MoneyBoxNavigationCrontroller: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var frame = self.navigationBar.bounds
        frame.size.height += statusBarHeight
        frame.origin.y -= statusBarHeight
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = frame
        visualEffectView.isUserInteractionEnabled = false
        self.navigationBar.addSubview(visualEffectView)
        visualEffectView.layer.zPosition = -1
        self.navigationBar.shadowImage = UIImage()
    }
    
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
