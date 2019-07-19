//
//  GoalsViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import AsyncDisplayKit
import IGListKit
import SnapKit

class GoalsViewController: ASViewController<ASDisplayNode>, IGoalsOutput {
    
    enum Constants {
        static let title = "My goals"
    }

    var onAddGoal: (() -> Void)?

    private let goalsCollectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var goalsListAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    private let presenter: IGoalsInput
    
    init(presenter: IGoalsInput) {
        self.presenter = presenter
        
        super.init(node: self.goalsCollectionNode)
        
        self.goalsListAdapter.setASDKCollectionNode(self.goalsCollectionNode)
        self.goalsListAdapter.collectionView = self.goalsCollectionNode.view
        self.goalsListAdapter.dataSource = self.presenter
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(openTestMenu))
        
        self.goalsCollectionNode.alwaysBounceVertical = true
        self.goalsCollectionNode.backgroundColor = .purple
        
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
