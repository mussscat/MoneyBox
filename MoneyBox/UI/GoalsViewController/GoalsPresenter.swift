//
//  GoalsPresenter.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 14/07/2019.
//  Copyright © 2019 Sergey Fedorov. All rights reserved.
//

import Foundation
import IGListKit
import AsyncDisplayKit

enum GoalsPresenterError: Error {
    case loadGoalContainersFailed
}

class GoalsPresenter: NSObject, IGoalsInput, ListAdapterDataSource {
    
    private let goalsService: ISavingsGoalService
    private let storage: IStorage
    weak var view: IGoalsOutput?
    private var containers = [GoalsContainer]()
    
    init(goalsService: ISavingsGoalService, storage: IStorage) {
        self.goalsService = goalsService
        self.storage = storage
    }
    
    func loadGoalContainers() {
        self.view?.showProgress()
        self.goalsService.fetchAllGoalsContainers { result in
            self.view?.hideProgress()
            
            do {
                let containers = try result.get()
                self.containers = containers
                self.view?.updateWithContainersLoaded()
            } catch {
                self.view?.showAlertView(error: error)
            }
        }
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.containers
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard object is GoalsContainer else {
            fatalError("Only containers supported for now")
        }
        
        return CategorySectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let node = ASDisplayNode()
        node.backgroundColor = .purple
        
        return node.view
    }
    
    // TEST
    
    func addCategory() {
        let category = SavingsGoalCategory(name: "Cat +\(Int.random(in: 0...10))", iconURL: nil)
        self.storage.createOrUpdate(objects: [category]) { result in
            do {
                let fetchedCategory = try result.get().first
                print(fetchedCategory!)
                self.view?.updateWithContainersLoaded()
            } catch {
                print(error)
            }
        }
    }
    
    func addCurrency() {
        let currency = Currency(name: "RUB+\(Int.random(in: 0...10))")
        self.storage.createOrUpdate(objects: [currency]) { result in
            do {
                let fetchedCurrency = try result.get().first
                print(fetchedCurrency!)
            } catch {
                print(error)
            }
        }
    }
}
