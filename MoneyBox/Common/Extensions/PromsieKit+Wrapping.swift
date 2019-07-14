//
//  PromsieKit+Wrapping.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import PromiseKit

public func wrap<T, E>(body: @escaping (@escaping (Swift.Result<T, E>) -> Void) -> Void) -> Promise<T> {
    return Promise { seal in
        body { result in
            switch result {
            case let .success(request): seal.fulfill(request)
            case let .failure(error): seal.reject(error)
            }
        }
    }
}
