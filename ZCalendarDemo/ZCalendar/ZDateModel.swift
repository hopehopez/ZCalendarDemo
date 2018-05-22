//
//  ZDateModel.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/3.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

public enum ZMonthType{
    case previous
    case current
    case next
}

final class ZDateModel: NSObject {
    
    static let dayCountPerRow = 7
    static let maxCellCount = 42
    
    //星期 文字
    var weeks = ("日", "一", "二", "三", "四", "五", "六")
    enum WeekType: String{
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        
        init?(_ indexPath: IndexPath) {
            let firstWeekday = Calendar.current.firstWeekday
            switch indexPath.row % 7 {
            case (8 -  firstWeekday) % 7:  self = .sunday
            case (9 -  firstWeekday) % 7:  self = .monday
            case (10 - firstWeekday) % 7:  self = .tuesday
            case (11 - firstWeekday) % 7:  self = .wednesday
            case (12 - firstWeekday) % 7:  self = .thursday
            case (13 - firstWeekday) % 7:  self = .friday
            case (14 - firstWeekday) % 7:  self = .saturday
            default: return nil
            }
        }
    }
    
    fileprivate var selectedDates = [Date: Bool]()
    fileprivate var currentDates = [Date]()
    fileprivate var currentDate = Date()
    fileprivate var calendar: Calendar {
        return Calendar.current //每次获取当前日历
    }
    
    
    override init() {
        super.init()
        setUp()
    }
    
    private func setUp() {
        selectedDates = [:]
        
        guard let indexAtBeginning = indexAtBeginning(in: .current) else {
            return
        }
        
        var components = DateComponents()
        //compactMap 过滤掉空值(nil)
        currentDates = (0..<ZDateModel.maxCellCount).compactMap({ (index) -> Date? in
            components.day = index - indexAtBeginning
            return calendar.date(byAdding: components, to: atBeginning(of: .current))
        }).map({ (date) -> Date in //map 遍历所有 不会过滤掉空值
            selectedDates[date] = false
            return date
        })
        
    }
    
    func date(at indexPath: IndexPath) -> Date {
        return currentDates[indexPath.row]
    }
    
    func week(at index: Int) -> String {
        switch index {
        case 0:
            return weeks.0
        case 1:
            return weeks.1
        case 2:
            return weeks.2
        case 3:
            return weeks.3
        case 4:
            return weeks.4
        case 5:
            return weeks.5
        case 6:
            return weeks.6
        default:
            return ""
        }
    }
    
    func display(in month: ZMonthType) {
        currentDates.removeAll()
        currentDate = month == .current ? Date() : date(of: month)
        setUp()
    }
    
    func select(with indexPath: IndexPath) {
        let selectedDate  = date(at: indexPath)
        
        selectedDates.forEach { (date, isSelected) in
            if selectedDate == date {
                selectedDates[date] = !selectedDates[date]!
            } else if isSelected {
                selectedDates[date] = false
            }
        }
    }
    
    func dateString(in month: ZMonthType, withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date(of: .current))
    }
    
    func dayString(at indexPath: IndexPath, isHiddenOtherMonth isHidden: Bool) -> String {
        if isHidden && isOtherMonth(at: indexPath) {
            return ""
        }
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "d"
        return formatter.string(from: currentDates[indexPath.row])
    }
    
    func isOtherMonth(at indexPath: IndexPath) -> Bool {
        if let beginning = indexAtBeginning(in: .current), let end = indexAtEnd(in: .current) , indexPath.row < beginning || indexPath.row  > end {
            return true
        }
        return false
    }
    
    func isSelect(with indexPath: IndexPath) -> Bool {
        let date = currentDates[indexPath.row]
        return selectedDates[date] ?? false
    }
    
    ///本月1号在时间数组中的下标
    func indexAtBeginning(in monthType: ZMonthType) -> Int? {
        //返回较小日历组件 在 较大日历组件内的序号
        if let index = calendar.ordinality(of: .day, in: .weekOfMonth, for: atBeginning(of: monthType)) {
            return index - 1
        }
        return nil
    }
    ///本月最后一天在时间数组中的下标
    func indexAtEnd(in monthType: ZMonthType) -> Int? {
        if let rangeDays = calendar.range(of: .day, in: .month, for: atBeginning(of: monthType)), let beginning = indexAtBeginning(in: monthType) {
            let count = rangeDays.upperBound - rangeDays.lowerBound
            return count + beginning - 1
        }
        return nil
    }
    
    ///拿到当前时间所在月份的第一天 的 date值
    func atBeginning(of monthType: ZMonthType) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date(of: monthType))
         components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
   ///当前时间 加减一个月 后 得到新的时间
    func date(of monthType: ZMonthType) -> Date {
        var components = DateComponents()
        components.month = {
            switch monthType {
            case .previous: return -1
            case .current:  return 0
            case .next:     return 1
            }
        }()
        return calendar.date(byAdding: components, to: currentDate) ?? Date()
    }
    
}
