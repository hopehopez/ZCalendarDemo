//
//  ZCalendarCell.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/11.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

class ZCalendarCell: UICollectionViewCell {
    
    fileprivate let contentLb: UILabel = .init()
    
    static let identifier = "ZCalendarCell"
    
    var content = "" {
        didSet{
            contentLb.text = content
            contentLb.sizeToFit()
             contentLb.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    var textColor: UIColor = UIColor.black {
        didSet {
           contentLb.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
//        contentLb.sizeToFit()
        contentLb.center = center
        contentLb.textColor = UIColor.lightGray
        addSubview(contentLb)
         contentLb.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
}
