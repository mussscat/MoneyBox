//
//  UIView+LoadFromNib.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 08.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        let bundle = Bundle(for: T.self)
        let views = bundle.loadNibNamed(nibName, owner: nil, options: nil)
        
        return views![0] as! T
    }
}

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        let instance = storyboard.instantiateViewController(withIdentifier: name)
        return instance as! T
    }
}
