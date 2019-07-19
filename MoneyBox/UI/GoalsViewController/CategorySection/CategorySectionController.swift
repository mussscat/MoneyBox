//
//  CategorySectionController.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

final class CategorySectionController: ListGenericSectionController<GoalsContainer>, ASSectionController, ListAdapterDataSource, ListSupplementaryViewSource {
    
    private var container: GoalsContainer?
    private lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        
        self.supplementaryViewSource = self
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = self.collectionContext else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width, height: 100)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let nodeBlock: ASCellNodeBlock = {
            let nibName = String(describing: EmbeddedCategoryGoalsCell.self)
            guard let cell = self.collectionContext?.dequeueReusableCell(withNibName: nibName,
                                                                         bundle: nil,
                                                                         for: self,
                                                                         at: index) as? EmbeddedCategoryGoalsCell else {
                                                                            fatalError()
            }
            
            self.adapter.collectionView = cell.embeddedGoalsCollectionView
            
            return cell
        }
        
        return nodeBlock
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        let nibName = String(describing: EmbeddedCategoryGoalsCell.self)
        guard let cell = self.collectionContext?.dequeueReusableCell(withNibName: nibName,
                                                                     bundle: nil,
                                                                     for: self,
                                                                     at: index) as? EmbeddedCategoryGoalsCell else {
                                                                        fatalError()
        }
        
        self.adapter.collectionView = cell.embeddedGoalsCollectionView
        
        return cell
    }
    
    
    override func didUpdate(to object: Any) {
        guard let container = object as? GoalsContainer else {
            return
        }
        
        self.container = container
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let container = self.container, let goals = container.goals else {
            return []
        }
        
        return goals
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return GoalsSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: ListSupplementaryViewSource
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let nibName = String(describing: CategoryHeaderSupplementaryCell.self)
        guard let view = self.collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                  for: self,
                                                                                  nibName: nibName,
                                                                                  bundle: nil,
                                                                                  at: index) as? CategoryHeaderSupplementaryCell else {
                                                                                fatalError()
        }
        
        guard let container = self.container else {
            fatalError()
        }
        
        let model = CategoryHeaderViewModel(categoryName: container.category.name)
        view.setup(with: model)
        
        return view

    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let context = self.collectionContext else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width, height: 40)
    }
}
