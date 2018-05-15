//
//  ZCalendar.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/9.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

@IBDesignable
public final class ZCalendar: UICollectionView {

    @IBInspectable public var isHiddenOtherMonth = false
    @IBInspectable public var sectionSpace: CGFloat = 1.5
    @IBInspectable public var cellSpace: CGFloat = 0.5
    @IBInspectable public var weekCellHeight: CGFloat = 25
    @IBInspectable public var currentDateFormat: String = "MM/yyyy"
    @IBInspectable public var weekColor: UIColor = .black
    @IBInspectable public var dayColor: UIColor = .gray
    @IBInspectable public var otherMonthColor: UIColor = .lightGray
    @IBInspectable public var weekBackgroundColor: UIColor = .white
    @IBInspectable public var dayBackgroundColor: UIColor = .white
    @IBInspectable public var holidayColor: UIColor = .red
    public var inset: UIEdgeInsets = .zero
    
    fileprivate  var model: ZDateModel = .init()
    fileprivate  var layout: ZCalendarLayout {
        return ZCalendarLayout(inset: inset, cellSpace: cellSpace, sectionSpace: sectionSpace, weekCellHeight: weekCellHeight)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
      
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionViewLayout = layout
          configure()
    }
    
    private func configure() {
        delegate = self
        dataSource = self
        isScrollEnabled = false
        
        register(ZCalendarCell.self, forCellWithReuseIdentifier: ZCalendarCell.identifier)
    }
    
}

extension ZCalendar: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? ZDateModel.dayCountPerRow : ZDateModel.maxCellCount
    }
    
    public  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZCalendarCell.identifier, for: indexPath) as! ZCalendarCell
        config(cell: cell, at: indexPath)
        return cell
    }
    
    func config(cell: ZCalendarCell,at indexPath: IndexPath) {
        let textColor: UIColor
        let isSelected: Bool
      
        let content: String
        
//        let date = model.date(at: indexPath)
        
        if indexPath.section == 0 {
            textColor = weekColor
            isSelected = false
            backgroundColor = weekBackgroundColor
            content = model.week(at: indexPath.row)
        } else {
            isSelected = model.isSelect(with: indexPath)
            
            textColor = {
                if let beginning = model.indexAtBeginning(in: .current), indexPath.row < beginning {
                    return otherMonthColor
                } else if let end = model.indexAtEnd(in: .current), indexPath.row > end {
                    return otherMonthColor
                } else if let type = ZDateModel.WeekType.init(indexPath), type == .sunday {
                    return weekColor
                } else if let type = ZDateModel.WeekType.init(indexPath), type == .saturday {
                    return weekColor
                } else {
                    return dayColor
                }
            }()
            
           content = model.dayString(at: indexPath, isHiddenOtherMonth: true)
        }
        
        cell.content = content
        cell.textColor = textColor
        cell.isSelected = isSelected
    }
    
}
