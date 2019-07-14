//
//  CategoryHeaderSupplementaryCell.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import UIKit

struct CategoryHeaderViewModel {
    var categoryName: String
}

class CategoryHeaderSupplementaryCell: UICollectionViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .green
    }
    
    func setup(with model: CategoryHeaderViewModel) {
        self.categoryNameLabel.text = model.categoryName
    }
}
