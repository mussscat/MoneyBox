//
//  GoalsListCollectionViewLayout.swift
//  MoneyBox
//
//  Created by Сергей Федоров on 02.09.2018.
//  Copyright © 2018 Sergey Fedorov. All rights reserved.
//

import UIKit

protocol GoalsListLayoutDelegate: class {
    
}

class GoalsListCollectionViewLayout: UICollectionViewLayout {
    
    override var collectionViewContentSize: CGSize {
        return .zero
    }
    
    override func prepare() {
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return nil
    }
}
