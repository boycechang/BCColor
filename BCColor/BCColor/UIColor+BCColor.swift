//
//  UIColor+BCColor.swift
//  BCColor
//
//  Created by Boyce on 3/21/16.
//  Copyright © 2016 Boyce. All rights reserved.
//
//
// YUV与RGB相互转换的公式如下(基于NTSC standard）︰
//　　Y = 0.299R + 0.587G + 0.114B
//　　U = -0.147R - 0.289G + 0.436B
//　　V = 0.615R - 0.515G - 0.100B
//

import UIKit

extension UIColor {
    /********** 颜色判断 **********/
    // 是否深色
    public var bc_isDark: Bool {
        let RGB = CGColorGetComponents(self.CGColor)
        return (0.299 * RGB[0] + 0.587 * RGB[1] + 0.114 * RGB[2]) < 0.5
    }
    
    // 是否黑白灰色系
    public var bc_isGray: Bool {
        let RGB = CGColorGetComponents(self.CGColor)
        let U = -0.147 * RGB[0] - 0.289 * RGB[1] + 0.436 * RGB[2]
        let V = 0.615 * RGB[0] - 0.515 * RGB[1] - 0.100 * RGB[2]
        return (fabs(U) <= 0.01 && fabs(V) <= 0.01)
    }
    
    // 是否接近黑白色
    public var bc_isBlackOrWhite: Bool {
        let RGB = CGColorGetComponents(self.CGColor)
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    // 是否有明显可辨色差
    public func bc_isDistinct(compareColor: UIColor) -> Bool {
        let bg = CGColorGetComponents(self.CGColor)
        let fg = CGColorGetComponents(compareColor.CGColor)
        let threshold: CGFloat = 0.25
        
        if fabs(bg[0] - fg[0]) > threshold || fabs(bg[1] - fg[1]) > threshold || fabs(bg[2] - fg[2]) > threshold {
            return !(self.bc_isGray && compareColor.bc_isGray)
        }
        return false
    }
    
    // 是否是明度对比色
    public func bc_isContrasting(compareColor: UIColor) -> Bool {
        let bg = CGColorGetComponents(self.CGColor)
        let fg = CGColorGetComponents(compareColor.CGColor)
        
        let bgLum = 0.299 * bg[0] + 0.587 * bg[1] + 0.114 * bg[2]
        let fgLum = 0.299 * fg[0] + 0.587 * fg[1] + 0.114 * fg[2]
        let contrast = (bgLum > fgLum) ? (bgLum + 0.05)/(fgLum + 0.05):(fgLum + 0.05)/(bgLum + 0.05)
        return 1.6 < contrast
    }
    
    
    /********** 颜色初始化 **********/
    // HexString 初始化
    public class func colorWithHex(hex: String) -> UIColor {
        return UIColor.colorWithHex(hex, alpha: 1.0)
    }
    
    public class func colorWithHex(hex: String, alpha: CGFloat) -> UIColor {
        let hexColor = strtoul(hex, nil, 16)
        let red = (CGFloat)((hexColor & 0xFF0000) >> 16);
        let green = (CGFloat)((hexColor & 0xFF00) >> 8);
        let blue = (CGFloat)(hexColor & 0xFF);
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    
    /********** 颜色处理 **********/
    // 反色
    var bc_inverseColor: UIColor {
        let RGB = CGColorGetComponents(self.CGColor)
        return UIColor(red: 1 - RGB[0], green: 1 - RGB[1], blue: 1 - RGB[2], alpha: RGB[3])
    }
}

