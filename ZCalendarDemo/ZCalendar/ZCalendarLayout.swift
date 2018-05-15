//
//  ZCalendarLayout.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/9.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

final class ZCalendarLayout: UICollectionViewLayout {

    let inset: UIEdgeInsets
    let cellSpace: CGFloat
    let sectionSpace: CGFloat
    let weekCellHeight: CGFloat
    let rowCount = 6
    let columnCount = 7
    
    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    init(inset: UIEdgeInsets, cellSpace: CGFloat, sectionSpace: CGFloat, weekCellHeight: CGFloat ) {
        self.inset = inset
        self.cellSpace = cellSpace
        self.sectionSpace = sectionSpace
        self.weekCellHeight = weekCellHeight
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        let sectionCount = collectionView?.numberOfSections ?? 0
        (0..<sectionCount).forEach { (section) in
            let itemCount = collectionView?.numberOfItems(inSection: section) ?? 0
            (0..<itemCount).forEach({ (row) in
                let indexPath: IndexPath = .init(row: row, section: section)
                let attribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                attribute.frame = frame(at: indexPath)
//                print(indexPath, attribute.frame)
                layoutAttributes[indexPath] = attribute
            })
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter({ (key, value) -> Bool in
            return rect.contains(value.frame)
        }).map({ (key, value) -> UICollectionViewLayoutAttributes in
                return value
            })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView?.frame.size ?? .zero
    }
    
    
    func frame(at indexPath: IndexPath) -> CGRect {
        let width = collectionView?.frame.width ?? 0
        let height = collectionView?.frame.height ?? 0
        
        let isWeekCell = indexPath.section == 0
        
        let availableWidth = width - cellSpace * CGFloat(columnCount - 1) - (inset.left +  inset.right)
        let availbaleHeight = height - cellSpace * CGFloat(rowCount - 1) - (inset.top + inset.bottom) - sectionSpace -  weekCellHeight
        
        var cellWidth = availableWidth / CGFloat(columnCount)
        let cellHeight = isWeekCell ? weekCellHeight : availbaleHeight / CGFloat(rowCount)
        
        let row = indexPath.row/columnCount
        let column = indexPath.row%columnCount
        
        let y = isWeekCell ? inset.top : inset.top + weekCellHeight + sectionSpace + (cellHeight + cellSpace) * CGFloat(row)
        let x = inset.left + (cellWidth + cellSpace) * CGFloat(column)
        
        if x + cellWidth > width, indexPath.row % 7 == 6  {
            cellWidth = width - x
        }
        
        return CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
    }
}
