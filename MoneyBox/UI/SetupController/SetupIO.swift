//
//  SetupIO.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation

protocol SetupOutput: AnyObject, IProgressDisplayable {
    func updateWithSetupFinished()
    func showRetriableError(_ error: Error)
}

protocol SetupInput: AnyObject {
    func setupPresenter()
}
