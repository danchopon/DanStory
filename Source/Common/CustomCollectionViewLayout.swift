//
//  CustomCollectionViewLayout.swift
//  DanStory
//
//  Created by Daniyar Erkinov on 9/10/19.
//  Copyright © 2019 danchopon.com. All rights reserved.
//

import UIKit

public protocol CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

public class CustomCollectionViewLayout: UICollectionViewLayout {
    
    public var delegate: CustomLayoutDelegate!
    private var showHeader = false
    private var showFooter = false
    
    public var numberOfColumns = 1
    public var cellPadding: CGFloat = 0.5
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override public func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        calculate(startIndex: 0, endIndex: collectionView.numberOfItems(inSection: 0), collectionView: collectionView)
    }
    
    func prepareNew(start startIndex: Int, end endIndex: Int) {
        guard let collectionView = collectionView else { return }
        calculate(startIndex: startIndex, endIndex: endIndex, collectionView: collectionView)
    }
    
    private func calculate(startIndex: Int, endIndex: Int, collectionView: UICollectionView) {
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in startIndex ..< endIndex {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let width = columnWidth - cellPadding * 2
            
            let photoHeight = delegate.collectionView(collectionView, heightForItemAt: indexPath, with: width)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    public override func invalidateLayout() {
        super.invalidateLayout()
        self.cache.removeAll()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
