//
//  SlideMenu.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/12/19.
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

enum ViewLayoutSetting: Int, CaseIterable {
    case oneColumn = 1
    case twoColumns = 2
    case threeColumns = 3
    
    var description: String {
        return String(describing: self.rawValue == 1 ? "\(self.rawValue) column" : "\(self.rawValue) columns")
    }
    
    var option: Int {
        return self.rawValue
    }
}

protocol SlideMenuDelegate: class {
    func changeOrderByFilter(orderBy: OrderByFilter)
    func changeNumberOfColumns(number: ViewLayoutSetting)
}

class SlideMenu: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let blackView = UIView()
    let cellHeight: CGFloat = 50
    let headerHeight: CGFloat = 40
    
    var filterTuple: (String, Int) = (OrderByFilter.latest.option, ViewLayoutSetting.oneColumn.option)
    
    weak var delegate: SlideMenuDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = cellHeight * CGFloat(OrderByFilter.allCases.count + ViewLayoutSetting.allCases.count) + headerHeight * CGFloat(FilterSection.allCases.count)
            let y = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    
    @objc private func handleDismiss() {
        dismiss()
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }
        }
    }
    
    override init() {
        super.init()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FilterViewCell.self, forCellWithReuseIdentifier: FilterViewCell.reuseID)
        collectionView.register(FilterViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterViewSectionHeader.reuseID)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FilterSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = FilterSection(rawValue: section) else { return 0 }
        switch section {
        case .orderBy:
            return OrderByFilter.allCases.count
        case .viewLayout:
            return ViewLayoutSetting.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewCell.reuseID, for: indexPath) as? FilterViewCell else {
            return UICollectionViewCell()
        }
        guard let section = FilterSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        let title: String
        let isActive: Bool
        switch section {
        case .orderBy:
            let orderByFilter = OrderByFilter.allCases[indexPath.item]
            title = orderByFilter.description
            isActive = filterTuple.0 == orderByFilter.option
        case .viewLayout:
            let layoutSetting = ViewLayoutSetting.allCases[indexPath.item]
            title = layoutSetting.description
            isActive = filterTuple.1 == layoutSetting.option
        }
        cell.configure(text: title, isActive: isActive)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = FilterSection(rawValue: indexPath.section) else { return }
        switch section {
        case .orderBy:
            filterTuple.0 = OrderByFilter.allCases[indexPath.item].option
            delegate?.changeOrderByFilter(orderBy: OrderByFilter.allCases[indexPath.item])
        case .viewLayout:
            filterTuple.1 = ViewLayoutSetting.allCases[indexPath.item].option
            delegate?.changeNumberOfColumns(number: ViewLayoutSetting.allCases[indexPath.item])
        }
        collectionView.reloadData()
        dismiss()
    }
}
