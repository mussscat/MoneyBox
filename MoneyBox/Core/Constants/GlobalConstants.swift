//
//  GlobalConstants.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 09.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case onboardingHasBeenShown = "onboardingHasBeenShownKey"
}

struct GlobalConstants {
    static var userDefaultsKeys = UserDefaultsKeys.self
}
