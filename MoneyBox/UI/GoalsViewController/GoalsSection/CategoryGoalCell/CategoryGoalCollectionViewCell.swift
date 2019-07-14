//
//  CategoryGoalCollectionViewCell.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import UIKit

struct CategoryGoalViewModel {
    var goalName: String
}

class CategoryGoalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var goalNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .yellow
    }

    func setup(with model: CategoryGoalViewModel) {
        self.goalNameLabel.text = model.goalName
    }
}
