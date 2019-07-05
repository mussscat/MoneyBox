//
//  Identifiable.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

protocol Identifiable {
    associatedtype Identifier
    
    var identifier: Identifier { get }
}
