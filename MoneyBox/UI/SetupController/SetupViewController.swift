//
//  SetupViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 08.10.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, SetupOutput {
    
    var onLoadingSucceeded: (() -> Void)?
    
    @IBOutlet weak var setupImageView: UIImageView!
    
    private let presenter: SetupInput
    
    init(presenter: SetupInput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupImageView.image = UIImage(named: "setupImage")
        
        self.presenter.setupPresenter()
    }
    
    func updateWithSetupFinished() {
        self.onLoadingSucceeded?()
    }
    
    func showRetriableError(_ error: Error) {
        DispatchQueue.main.async {
            self.showAlertView(error: error) {
                self.presenter.setupPresenter()
            }
        }
    }
}
