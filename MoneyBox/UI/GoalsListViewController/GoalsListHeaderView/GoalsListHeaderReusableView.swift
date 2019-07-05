//
//  GoalsListHeaderReusableView.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02.09.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

class GoalsListHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with sectionName: String) {
        self.titleLabel.text = sectionName
    }
}
