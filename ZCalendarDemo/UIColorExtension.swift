//
//  UIColorExtension.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/11.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

func color(value: uint) -> UIColor{
    return UIColor.init(red: CGFloat(value & 0xff0000 >> 16)/255.0, green: CGFloat(value & 0xff00 >> 16)/255.0, blue: CGFloat(value & 0xff >> 16)/255.0, alpha: 1.0)
}
