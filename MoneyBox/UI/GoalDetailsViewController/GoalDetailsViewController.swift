//
//  GoalDetailsViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 28.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

class GoalDetailsViewController: UIViewController {
    
    private let goal: GoalPlainObject
    
    init(with goal: GoalPlainObject) {
        self.goal = goal
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
