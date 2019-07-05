//
//  DatePickerView.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 12/03/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import UIKit

@IBDesignable class DatePickerView: UIView {
    
    var onDateChanged: ((Date) -> Void)?
    
    private let datePicker = UIDatePicker(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.datePicker.datePickerMode = .date
        self.datePicker.locale = Locale(identifier: "ruRU")
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        self.addSubview(self.datePicker)
        self.datePicker.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 1).isActive = true
        self.datePicker.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 1).isActive = true
        self.datePicker.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1).isActive = true
        self.datePicker.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 1).isActive = true
    }
    
    func configureWithDate(_ date: Date?) {
        self.datePicker.date = date ?? Date()
    }
    
    @objc private func datePickerValueChanged() {
        self.onDateChanged?(self.datePicker.date)
    }
}
