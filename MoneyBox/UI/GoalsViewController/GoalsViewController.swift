//
//  GoalsViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit

class GoalsViewController: UIViewController, IGoalsOutput {
    
    var onAddGoal: (() -> Void)?

    private let goalsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var goalsListAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    private let presenter: IGoalsInput
    
    init(presenter: IGoalsInput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(openTestMenu))
        
        self.goalsCollectionView.alwaysBounceVertical = true
        self.goalsCollectionView.backgroundColor = .purple
        self.view.addSubview(self.goalsCollectionView)
        self.goalsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.goalsListAdapter.collectionView = self.goalsCollectionView
        self.goalsListAdapter.dataSource = self.presenter
        
        self.presenter.loadGoalContainers()
    }
    
    func updateWithContainersLoaded() {
        self.goalsListAdapter.performUpdates(animated: true)
    }
    
    @objc private func openTestMenu() {
        let testMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addCategoryButton = UIAlertAction(title: "Category", style: .default) { [weak self] _ in
            self?.presenter.addCategory()
        }
        let addCurrencyButton = UIAlertAction(title: "Currency", style: .default) { [weak self] _ in
            self?.presenter.addCurrency()
        }
        let addGoalButton = UIAlertAction(title: "Goal", style: .default) { [weak self] _ in
            self?.onAddGoal?()
        }
        let closeAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak testMenu] _ in
            testMenu?.dismiss(animated: true)
        }
        
        testMenu.addAction(addCategoryButton)
        testMenu.addAction(addCurrencyButton)
        testMenu.addAction(addGoalButton)
        testMenu.addAction(closeAction)
        
        self.present(testMenu, animated: true)
    }
}
