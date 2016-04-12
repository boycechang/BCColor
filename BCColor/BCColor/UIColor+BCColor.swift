//
//  UIColor+BCColor.swift
//  BCColor
//
//  Created by Boyce on 3/21/16.
//  Copyright © 2016 Boyce. All rights reserved.
//
//
// RGB To YUV (NTSC standard）︰
//　　Y = 0.299R + 0.587G + 0.114B
//　　U = -0.147R - 0.289G + 0.436B
//　　V = 0.615R - 0.515G - 0.100B
//

import UIKit

extension UIColor {
    
    /********** Evaluation **********/
    
    public var bc_isDark: Bool {
        let RGB = CGColorGetComponents(self.CGColor)
        return (0.299 * RGB[0] + 0.587 * RGB[1] + 0.114 * RGB[2]) < 0.5
    }
    
    public var bc_isGray: Bool {
        let RGB = CGColorGetComponents(self.CGColor)
        let U = -0.147 * RGB[0] - 0.289 * RGB[1] + 0.436 * RGB[2]
        let V = 0.615 * RGB[0] - 0.515 * RGB[1] - 0.100 * RGB[2]
        return (fabs(U) <= 0.002 && fabs(V) <= 0.002)
    }
    
    public var bc_isBlackOrWhite: Bool {
        let RGB = CGColorGetComponents(self.CGColor)
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    public func bc_isDistinct(compareColor: UIColor) -> Bool {
        let bg = CGColorGetComponents(self.CGColor)
        let fg = CGColorGetComponents(compareColor.CGColor)
        let threshold: CGFloat = 0.25
        
        if fabs(bg[0] - fg[0]) > threshold || fabs(bg[1] - fg[1]) > threshold || fabs(bg[2] - fg[2]) > threshold {
            return !(self.bc_isGray && compareColor.bc_isGray)
        }
        return false
    }
    
    public func bc_isContrasting(compareColor: UIColor) -> Bool {
        let bg = CGColorGetComponents(self.CGColor)
        let fg = CGColorGetComponents(compareColor.CGColor)
        
        let bgLum = 0.299 * bg[0] + 0.587 * bg[1] + 0.114 * bg[2]
        let fgLum = 0.299 * fg[0] + 0.587 * fg[1] + 0.114 * fg[2]
        let contrast = (bgLum > fgLum) ? (bgLum + 0.05)/(fgLum + 0.05):(fgLum + 0.05)/(bgLum + 0.05)
        return 1.4 < contrast
    }
    
    
    
    /********** Hex Color **********/
    
    public class func colorWithHex(hex: String) -> UIColor? {
        return UIColor.colorWithHex(hex, alpha: 1.0)
    }
    
    public class func colorWithHex(hex: String, alpha: CGFloat) -> UIColor? {
        if (hex.isEmpty) {
            return nil;
        }
        
        var hexValue = hex
        
        if hexValue[hexValue.startIndex] == "#" {
            hexValue.removeAtIndex(hex.startIndex)
        }
        
        if hexValue.characters.count != 6 && hexValue.characters.count  != 3 {
            return nil;
        }
        
        if hexValue.characters.count == 3 {
            hexValue.insert(hexValue[hexValue.startIndex], atIndex: hexValue.startIndex.advancedBy(0))
            hexValue.insert(hexValue[hexValue.startIndex.advancedBy(2)], atIndex: hexValue.startIndex.advancedBy(2))
            hexValue.insert(hexValue[hexValue.startIndex.advancedBy(4)], atIndex: hexValue.startIndex.advancedBy(4))
        }

        let hexColor = strtoul(hexValue, nil, 16)
        let red = (CGFloat)((hexColor & 0xFF0000) >> 16);
        let green = (CGFloat)((hexColor & 0xFF00) >> 8);
        let blue = (CGFloat)(hexColor & 0xFF);
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }

    
    
    /********** Process **********/
    
    var bc_inverseColor: UIColor {
        let RGB = CGColorGetComponents(self.CGColor)
        return UIColor(red: 1 - RGB[0], green: 1 - RGB[1], blue: 1 - RGB[2], alpha: RGB[3])
    }
    
    func bc_lightenByPercentage(percentage: CGFloat) -> UIColor {
        var h : CGFloat = 0.0
        var s : CGFloat = 0.0
        var b : CGFloat = 0.0
        var a : CGFloat = 0.0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        b = max(min(b + percentage, 1.0), 0.0)
        
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    func bc_darkenByPercentage(percentage: CGFloat) -> UIColor {
        return self.bc_lightenByPercentage(-percentage)
    }
    
    
}

