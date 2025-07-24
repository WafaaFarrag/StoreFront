//
//  SkeletonCollectionView+Extensions.swift
//  StoreFront
//
//  Created by wafaa farrag on 24/07/2025.
//

import Foundation
import RxDataSources
import SkeletonView

extension RxCollectionViewSectionedReloadDataSource: SkeletonCollectionViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    public func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ProductCollectionViewCell"
    }
}
