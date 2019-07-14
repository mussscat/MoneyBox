//
//  EmbeddedCategoryGoalsCell.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import UIKit

class EmbeddedCategoryGoalsCell: UICollectionViewCell {
    
    @IBOutlet weak var embeddedGoalsCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.embeddedGoalsCollectionView.bounces = true
        self.embeddedGoalsCollectionView.alwaysBounceHorizontal = true
        self.embeddedGoalsCollectionView.backgroundColor = .red
    }
}
