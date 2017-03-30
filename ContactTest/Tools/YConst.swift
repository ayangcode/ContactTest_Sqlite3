//
//  YConst.swift
//  ContactTest
//
//  Created by smile on 2017/3/29.
//  Copyright © 2017年 ayang. All rights reserved.
//

import Foundation
import UIKit

// MARK:- | ****** 尺寸 ****** |
/**
 * 尺寸5s、6s、6s_Plus
 */
let Y6SScreenW:CGFloat = 375 // 6s / 6
let Y6SScreenH:CGFloat = 667

let Y5SScreenW:CGFloat = 320 // 5s / 5
let Y5SScreenH:CGFloat = 568

let Y6PlusScreenW:CGFloat = 414 // 6plus / 6s plus
let Y6PlusScreenH:CGFloat = 736

/**
 * 屏幕宽、高
 */
let YScreenW:CGFloat = UIScreen.main.bounds.size.width
let YScreenH:CGFloat = UIScreen.main.bounds.size.height

/**
 * 按比例适配大小 (以6s为基本)
 */
func auto_width(value:CGFloat) -> CGFloat { // 返回适配过的宽度
    return value * (YScreenW / Y6SScreenW)
}
func auto_height(value:CGFloat) -> CGFloat {// 返回适配过的高度
    return value * (YScreenH / Y6SScreenH)
}

// MARK:- | ****** 字体 ****** |
let MY_Font = "Menlo"
let MY_Font_Title_Size = auto_width(value: 17)
let MY_Font_SubTitle_Size = auto_width(value: 13)

