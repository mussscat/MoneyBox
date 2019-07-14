//
//  GoalsSectionController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import IGListKit

class GoalsSectionController: ListSectionController {
    
    private var goal: SavingsGoal?
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = self.collectionContext else {
            return .zero
        }
        
        let height = context.containerSize.height
        return CGSize(width: height, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let nibName = String(describing: CategoryGoalCollectionViewCell.self)
        guard let cell = self.collectionContext?.dequeueReusableCell(withNibName: nibName,
                                                                     bundle: nil,
                                                                     for: self,
                                                                     at: index) as? CategoryGoalCollectionViewCell else {
                                                                        fatalError()
        }
        
        guard let goal = self.goal else {
            fatalError()
        }
        
        let model = CategoryGoalViewModel(goalName: goal.name)
        cell.setup(with: model)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let goal = object as? SavingsGoal else {
            return
        }
        
        self.goal = goal
    }
}
