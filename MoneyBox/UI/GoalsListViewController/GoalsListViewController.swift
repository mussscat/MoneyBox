//
//  GoalsListViewController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 26.08.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

class GoalsListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private enum Constants {
        static let goalCellReuseId = "\(GoalsListCollectionViewCell.self)"
        static let title = "Saved goals"
        static let sectionHeaderReuseId = "\(GoalsListHeaderReusableView.self)"
    }
    
    private var goalsService: ISavingsGoalService
    private var goals: [Goal]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    init(goalsService: ISavingsGoalService) {
        self.goalsService = goalsService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.title

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: Constants.goalCellReuseId, bundle: Bundle.main),
                                     forCellWithReuseIdentifier: Constants.goalCellReuseId)
        
        self.updateGoalsList()
    }
    
    private func updateGoalsList() {
        self.goalsService.fetchAllGoals { [weak self] result in
            result.withValue({ goals in
                self?.goals = goals
                self?.collectionView.reloadData()
            })
        }
    }
    
    // MARK: - UIColelctionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goals?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.goalCellReuseId,
                                                      for: indexPath)
        guard
            let goalCell = cell as? GoalsListCollectionViewCell,
            let goal = self.goals?[indexPath.row]
        else {
            assertionFailure()
            return UICollectionViewCell()
        }
        
        return goalCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let goal = self.goals?[indexPath.row] else {
            return
        }
        
        let detailsController = GoalDetailsViewController(with: goal)
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: 400)
    }
}
