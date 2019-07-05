//
//  GoalsListCollectionViewCell.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 26.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

class GoalsListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var deadlineOrPeriodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.deadlineOrPeriodLabel.isHidden = true
    }
    
    func setup(with name: String, amount: String, currency: String, deadline: String?) {
        self.nameLabel.text = name
        self.amountLabel.text = amount
        self.currencyLabel.text = currency
        
        if deadline != nil {
            self.deadlineOrPeriodLabel.isHidden = false
            self.deadlineOrPeriodLabel.text = deadline
        }
    }
}
