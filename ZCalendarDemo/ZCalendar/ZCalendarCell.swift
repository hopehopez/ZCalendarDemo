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
    fileprivate let circleView = UIView()
    
    static let identifier = "ZCalendarCell"
    
    var content = ""
    var textColor: UIColor = UIColor.black
    
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
        backgroundColor = color(0x2b314f)
        
        circleView.backgroundColor = color(0xf87777)
        circleView.layer.cornerRadius = bounds.width/2.0
        circleView.layer.masksToBounds = true
        circleView.frame = bounds
        addSubview(circleView)
        circleView.isHidden = true
        
        contentLb.center = center
        contentLb.textColor = UIColor.lightGray
        addSubview(contentLb)
        contentLb.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
    }
    
    func config(text: String, textColor: UIColor, isSelected: Bool) {
        
        contentLb.textColor = textColor
        contentLb.text = text
        contentLb.sizeToFit()
        contentLb.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        circleView.frame = bounds
        circleView.isHidden = !isSelected
        
    }
    
}
