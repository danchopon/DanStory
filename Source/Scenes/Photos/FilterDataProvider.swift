//
//  FilterDataProvider.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/16/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

enum FilterSection: Int, CaseIterable {
    case orderBy
    case viewLayout
    
    var description: String {
        switch self {
        case .orderBy:
            return "Order by"
        case .viewLayout:
            return "List Layout"
        }
    }
}

protocol DataProvider {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func section(_ collectionView: UICollectionView, of kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    func totalNumberOfItems() -> Int
}

class FilterDataProvider: NSObject, DataProvider {
    enum ViewLayoutSetting: Int, CaseIterable {
        case oneColumn = 1
        case twoColumns = 2
        case threeColumns = 3
        
        var description: String {
            return String(describing: self.rawValue == 1 ? "\(self.rawValue) column" : "\(self.rawValue) columns")
        }
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard let section = FilterSection(rawValue: section) else { return 0 }
        switch section {
        case .orderBy:
            return OrderByFilter.allCases.count
        case .viewLayout:
            return ViewLayoutSetting.allCases.count
        }
    }
    
    func totalNumberOfItems() -> Int {
        return OrderByFilter.allCases.count + ViewLayoutSetting.allCases.count
    }
    
    func item(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewCell.reuseID, for: indexPath) as? FilterViewCell else {
            return UICollectionViewCell()
        }
        guard let section = FilterSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        let title: String
        switch section {
        case .orderBy: title = OrderByFilter.allCases[indexPath.item].description
        case .viewLayout: title = ViewLayoutSetting.allCases[indexPath.item].description
        }
        cell.configure(text: title)
        return cell
    }
    
    func numberOfSections() -> Int {
        return FilterSection.allCases.count
    }
    
    func section(_ collectionView: UICollectionView, of kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterViewSectionHeader.reuseID, for: indexPath) as? FilterViewSectionHeader else {
                assert(false, "Invalid view type")
            }
            headerView.configure(text: FilterSection.allCases[indexPath.section].description)
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
}

