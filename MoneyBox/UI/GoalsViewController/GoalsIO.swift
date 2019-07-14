//
//  IGoalsIO.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import IGListKit

protocol IGoalsInput: ListAdapterDataSource {
    func loadGoalContainers()
    
    //TEST
    func addCategory()
    func addCurrency()
}

protocol IGoalsOutput: AnyObject, IProgressDisplayable, AlertViewDisplayable {
    func updateWithContainersLoaded()
}
