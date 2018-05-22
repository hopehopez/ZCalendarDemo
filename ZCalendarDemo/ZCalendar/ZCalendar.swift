//
//  ZCalendar.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/9.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

@objc public protocol ZCalendarDelegate: NSObjectProtocol {
    @objc optional func calendar(_ calendar: ZCalendar, didSelect date: Date?, forItemAt indexPath: IndexPath)
    @objc optional func calendar(_ calendar: ZCalendar, current dateString: String)
}

@IBDesignable
public final class ZCalendar: UICollectionView {

    @IBInspectable public var isHiddenOtherMonth = true
    @IBInspectable public var sectionSpace: CGFloat = 0
    @IBInspectable public var cellSpace: CGFloat = 0
    @IBInspectable public var weekCellHeight: CGFloat = 50
    @IBInspectable public var currentDateFormat: String = "yyyy年MM月"
    @IBInspectable public var weekColor: UIColor = .white
    @IBInspectable public var dayColor: UIColor = .white
    @IBInspectable public var otherMonthColor: UIColor = .lightGray
    @IBInspectable public var weekBackgroundColor: UIColor = .white
    @IBInspectable public var dayBackgroundColor: UIColor = .white
    @IBInspectable public var holidayColor: UIColor = .red
    
    @IBInspectable public var calendarDelegate: ZCalendarDelegate?
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
    
    public func currentDateString(withFormat format: String) -> String {
        return model.dateString(in: .current, withFormat: format)
    }
    
    public func display(in month: ZMonthType) {
        model.display(in: month)
        reloadData()
        calendarDelegate?.calendar?(self, current: model.dateString(in: .current, withFormat: "yyyy年MM月"))
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section != 0 else {
            return
        }
        
        if isHiddenOtherMonth && model.isOtherMonth(at: indexPath) {
            return
        }
        
        model.select(with: indexPath)
        
        reloadData()
        
        calendarDelegate?.calendar!(self, didSelect: model.date(at: indexPath), forItemAt: indexPath)
        
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
            
           content = model.dayString(at: indexPath, isHiddenOtherMonth: isHiddenOtherMonth)
        }
        
        cell.config(text: content, textColor: textColor, isSelected: isSelected)
    }
    
}
