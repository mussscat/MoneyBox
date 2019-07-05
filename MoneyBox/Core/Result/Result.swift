//
//  Result.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 19.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import Foundation

extension Result {
    
    func withValue(_ handler: (Success) -> Void, errorHandler: ((Error) -> Void)? = nil) {
        switch self {
        case .success(let success):
            handler(success)
        case .failure(let error):
            errorHandler?(error)
        }
    }
    
}
