//
//  GoalsContainer.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import IGListKit

class GoalsContainer {
    var category: SavingsGoalCategory
    var goals: [SavingsGoal]?
    
    init(category: SavingsGoalCategory, goals: [SavingsGoal]?) {
        self.category = category
        self.goals = goals
    }
}

extension GoalsContainer: Equatable {
    static public func ==(rhs: GoalsContainer, lhs: GoalsContainer) -> Bool {
        return
            (rhs.category.identifier == lhs.category.identifier) &&
            (lhs.goals?.count == rhs.goals?.count)
    }
}

extension GoalsContainer: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.category.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? GoalsContainer else {
            return false
        }
        
        return self == object
    }
}
