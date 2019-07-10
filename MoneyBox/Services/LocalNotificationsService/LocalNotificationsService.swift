//
//  LocalNotificationsService.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation
import UserNotifications

protocol ILocalNotificationsService {
    func registerForLocalNotifications(options: [UNAuthorizationOptions], completion: ((Bool) -> Void))
    func cancelAllNotifications()
    
    
}
