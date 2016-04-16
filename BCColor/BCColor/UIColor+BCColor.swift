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
    
    // MARK: - Color Evalutation
    
    /// Boolean value indicating if the color `isDark`.
    public var isDark: Bool {
        // get the rgba values of the color
        let RGB = CGColorGetComponents(self.CGColor)
        
        // this algorithm uses the the constants (0.299,0.587,0.114) to determine the brightness of the color and if it is less than half (0.5) than it is considered dark
        return (0.299*RGB[0] + 0.587*RGB[1] + 0.114*RGB[2]) < 0.5
    }
    
    /// Boolean value indicating if the color `isGray`.
    public var isGray: Bool {
        // get the rgba values of the color
        let RGB = CGColorGetComponents(self.CGColor)
        
        // compute color values that help us determine if the color is gray
        let U = -0.147*RGB[0] - 0.289*RGB[1] + 0.436*RGB[2]
        let V = 0.615*RGB[0] - 0.515*RGB[1] - 0.100*RGB[2]
        
        // check if the U and V values we computed are equivalent to that of gray
        return (abs(U) <= 0.002 && abs(V) <= 0.002)
    }
    
    /// Boolean value indicating if the color `isBlackOrWhite`.
    public var isBlackOrWhite: Bool {
        // get the rgba values of the color
        let RGB = CGColorGetComponents(self.CGColor)
        
        // check if the color values match that of white or black
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    /**
     Checks if the color `isDisctinct` from another.
     - Parameter compareColor: The `UIColor` that `self` will be compared with.
     - Returns: A boolean value inidcating if the color is different than the other. `true = distinct` | `false = not distinct`.*/
    public func isDistinct(compareColor: UIColor) -> Bool {
        // get the rgba values for our self
        let bg = CGColorGetComponents(self.CGColor)
        
        // get the rgba values for the color we are comparing to
        let fg = CGColorGetComponents(compareColor.CGColor)
        
        // set a constant threshold
        let threshold: CGFloat = 0.25
        
        // check if they are distinct
        if (abs(bg[0]-fg[0]) > threshold) || (abs(bg[1]-fg[1]) > threshold) || (abs(bg[2]-fg[2]) > threshold) {
            return !(isGray && compareColor.isGray)
        }
        
        // return that they are not distinct
        return false
    }
    
    
    public func isContrasting(compareColor: UIColor) -> Bool {
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
            return nil
        }
        
        var hexValue = hex
        
        if hexValue[hexValue.startIndex] == "#" {
            hexValue.removeAtIndex(hex.startIndex)
        }
        
        if hexValue.characters.count != 6 && hexValue.characters.count  != 3 {
            return nil
        }
        
        if hexValue.characters.count == 3 {
            hexValue.insert(hexValue[hexValue.startIndex], atIndex: hexValue.startIndex.advancedBy(0))
            hexValue.insert(hexValue[hexValue.startIndex.advancedBy(2)], atIndex: hexValue.startIndex.advancedBy(2))
            hexValue.insert(hexValue[hexValue.startIndex.advancedBy(4)], atIndex: hexValue.startIndex.advancedBy(4))
        }

        let hexColor = strtoul(hexValue, nil, 16)
        let red = (CGFloat)((hexColor & 0xFF0000) >> 16)
        let green = (CGFloat)((hexColor & 0xFF00) >> 8)
        let blue = (CGFloat)(hexColor & 0xFF)
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
    
    
    /********** Gradient **********/
    /* startPoint / endPoint : (0, 0) is the left top corner, (1, 1) is the right botttom corner
     */
    public class func bc_gradientColor(startPoint: CGPoint, endPoint: CGPoint, frame: CGRect, colors: Array<UIColor>) -> UIColor? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        var cgColors = [AnyObject]()
        for color in colors {
            cgColors.append(color.CGColor)
        }
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.mainScreen().scale)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: gradientImage)
    }
    
    public class func bc_radialGradientColor(frame: CGRect, colors: Array<UIColor>) -> UIColor? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        var cgColors = [AnyObject]()
        for color in colors {
            cgColors.append(color.CGColor)
        }
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let arrayRef = cgColors as CFArrayRef
        let gradient = CGGradientCreateWithColors(colorspace, arrayRef, nil)
        let centrePoint = CGPointMake(0.5 * frame.size.width, 0.5 * frame.size.height)
        let radius = max(frame.size.width, frame.size.height) * 0.5
        
        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, centrePoint,
                                     0, centrePoint, radius,
                                     CGGradientDrawingOptions.DrawsAfterEndLocation)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return UIColor(patternImage: gradientImage)
    }
}

