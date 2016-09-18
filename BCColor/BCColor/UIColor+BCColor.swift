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
        let RGB = self.cgColor.components
        
        // this algorithm uses the the constants (0.299,0.587,0.114) to determine the brightness of the color and if it is less than half (0.5) than it is considered dark
        let b1 = 0.299 * RGB![0]
        let b2 = 0.587 * RGB![1]
        let b3 = 0.114 * RGB![2]
        let brightness = b1 + b2 + b3
        return brightness < 0.5
    }
    
    /// Boolean value indicating if the color `isGray`.
    public var isGray: Bool {
        // get the rgba values of the color
        let RGB = self.cgColor.components
        
        // compute color values that help us determine if the color is gray
        let U1 = -0.147 * RGB![0]
        let U2 = 0.289 * RGB![1]
        let U3 = 0.436 * RGB![2]
        let U = U1 - U2 + U3
        
        let V1 = 0.615 * RGB![0]
        let V2 = 0.515 * RGB![1]
        let V3 = 0.100 * RGB![2]
        let V = V1 - V2 - V3
        
        // check if the U and V values we computed are equivalent to that of gray
        return (abs(U) <= 0.002 && abs(V) <= 0.002)
    }
    
    /// Boolean value indicating if the color `isBlackOrWhite`.
    public var isBlackOrWhite: Bool {
        // get the rgba values of the color
        let RGB = self.cgColor.components
        
        // check if the color values match that of white or black
        return (RGB![0] > 0.91 && RGB![1] > 0.91 && RGB![2] > 0.91) || (RGB![0] < 0.09 && RGB![1] < 0.09 && RGB![2] < 0.09)
    }
    
    /**
     Checks if the color `isDisctinct` from another.
     - Parameter compareColor: The `UIColor` that `self` will be compared with.
     - Returns: A boolean value inidcating if the color is different than the other. `true = distinct` | `false = not distinct`.
     */
    public func isDistinct(_ compareColor: UIColor) -> Bool {
        // get the rgba values for our self
        let bg = self.cgColor.components
        
        // get the rgba values for the color we are comparing to
        let fg = compareColor.cgColor.components
        
        // set a constant threshold
        let threshold: CGFloat = 0.25
        
        // check if they are distinct
        if (abs((bg?[0])!-(fg?[0])!) > threshold) || (abs((bg?[1])!-(fg?[1])!) > threshold) || (abs((bg?[2])!-(fg?[2])!) > threshold) {
            return !(isGray && compareColor.isGray)
        }
        
        // return that they are not distinct
        return false
    }
    
    /**
     Checks if the color `isContrasting` with another color.
     - Parameter compareColor: The `UIColor` that is being compared to `self`.
     - Returns: A boolean value indicating the if the two colors contrast.
     */
    public func isContrasting(_ compareColor: UIColor) -> Bool {
        // get the rgba values for self
        let bg = self.cgColor.components
        
        // get the rgba values for the color we are comparing with
        let fg = compareColor.cgColor.components
        
        // compute the brightness of both colors
        let bgLum1 = 0.299 * bg![0]
        let bgLum2 = 0.587 * bg![1]
        let bgLum3 = 0.114 * bg![2]
        let bgLum = bgLum1 + bgLum2 + bgLum3
        
        let fgLum1 = 0.299 * fg![0]
        let fgLum2 = 0.587 * fg![1]
        let fgLum3 = 0.114 * fg![2]
        let fgLum = fgLum1 + fgLum2 + fgLum3
        
        // calculate the contrast using the values we just computed
        let contrast = (bgLum > fgLum) ? (bgLum+0.05)/(fgLum+0.05) : (fgLum+0.05)/(bgLum+0.05)
        
        // check if they contrast
        return 1.4 < contrast
    }
    
    // MARK: - Hex Color
    
    /**
     Takes the _`hex`_ string and generates the `UIColor` from it.
     - Parameter hex: The `String` of a _`hex`_ color code.
     - Returns: A `UIColor` (if possible) that matches the _`hex`_.
     */
    public class func colorWithHex(_ hex: String) -> UIColor? {
        return UIColor.colorWithHex(hex, alpha: 1.0)
    }
    
    /**
     Takes the _`hex`_ string and generates the `UIColor` from it.
     - Parameter hex: The `String` of a _`hex`_ color code.
     - Parameter alpha: The `alpha` value for the _`hex`_ color code.
     - Returns: A `UIColor` (if possible) that matches the _`hex`_ and has the _`alpha`_ matching the input.
     */
    public class func colorWithHex(_ hex: String, alpha: CGFloat) -> UIColor? {
        // check if the string is empty
        if (hex.isEmpty) {
            return nil
        }
        
        // get a variable value for the hex string
        var hexValue = hex
        
        // get rid of the # (hashtag) if there is one
        if hexValue[hexValue.startIndex] == "#" {
            hexValue.remove(at: hex.startIndex)
        }
        
        // make sure the hexValue is valid in length
        if hexValue.characters.count != 6 && hexValue.characters.count != 3 {
            return nil
        }
        
        // if there are not enough character in hexValue we will just add them
        if hexValue.characters.count == 3 {
            hexValue.insert(hexValue[hexValue.startIndex], at: hexValue.characters.index(hexValue.startIndex, offsetBy: 0))
            hexValue.insert(hexValue[hexValue.characters.index(hexValue.startIndex, offsetBy: 2)], at: hexValue.characters.index(hexValue.startIndex, offsetBy: 2))
            hexValue.insert(hexValue[hexValue.characters.index(hexValue.startIndex, offsetBy: 4)], at: hexValue.characters.index(hexValue.startIndex, offsetBy: 4))
        }

        // get the hex color as a UInt value
        let hexColor = strtoul(hexValue, nil, 16)
        
        // calculate the rgb values
        let red = CGFloat((hexColor & 0xFF0000) >> 16)
        let green = CGFloat((hexColor & 0xFF00) >> 8)
        let blue = CGFloat(hexColor & 0xFF)
        
        // return a UIColor with the values we got from the hex string and the alpha inputed
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    // MARK: Color Processing
    
    /// `UIColor` value that represents the inverse of `self`.
    var inverseColor: UIColor {
        // get the rgba values of self
        let RGB = self.cgColor.components
        
        // calculate the inverse color
        return UIColor(red: 1 - RGB![0], green: 1 - RGB![1], blue: 1 - RGB![2], alpha: RGB![3])
    }
    
    /**
     Lightens the color by a given `percentage`.
     - Parameter percentage: The `percentage` to lighten by. Values between 0–1.0 are accepted.
     - Returns: A new `UIColor` lightened by a given `percentage`.
     */
    public func lightenByPercentage(_ percentage: CGFloat) -> UIColor {
        // get the hue, sat, brightness, and alpha values
        var h : CGFloat = 0.0
        var s : CGFloat = 0.0
        var b : CGFloat = 0.0
        var a : CGFloat = 0.0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        // increase the brightness value, max makes sure brightness does not go below 0 and min ensures that the brightness value does not go above 1.0
        b = max(min(b + percentage, 1.0), 0.0)
        
        // return a new UIColor with the new values
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    /**
     Darkens the color by a given `percentage`.
     - Parameter percentage: The `percentage` to darken by. Values between 0–1.0 are accepted.
     - Returns: A new `UIColor` darkened by a given `percentage`.
     */
    public func darkenByPercentage(_ percentage: CGFloat) -> UIColor {
        return self.lightenByPercentage(-percentage)
    }
    
    
    // MARK: Gradient Methods
    
    /* startPoint / endPoint : (0, 0) is the left top corner, (1, 1) is the right botttom corner
     */
    
    /**
     Creates a gradient color.
     - Parameter startPoint: The `CGPoint` to start the gradient at. _Note: (0,0) is the top left corner._
     - Parameter endPoint: The `CGPoint` to start the gradient at. _Note: (1,1) is the bottom right corner._
     - Parameter frame: The frame of the gradient.
     - Parameter colors: An array of `UIColor`'s that will be included in the gradient.
     - Returns: A new gradient `UIColor`.
     */
    public class func gradientColor(_ startPoint: CGPoint, endPoint: CGPoint, frame: CGRect, colors: [UIColor]) -> UIColor? {
        // init a CAGradientLayer and set its frame
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        
        // turn the array of UIColor's into an array of CGColor's
        let cgColors = colors.map({$0.cgColor})
        
        // set the colors of the gradient
        gradientLayer.colors = cgColors
        
        // set the start and end points of the gradient
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        // start an image context
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
        
        // draw the gradient layer in the context
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        // get the image of the gradient from the current image context
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the context
        UIGraphicsEndImageContext()
        
        // return a new UIColor using the gradient image we made
        return UIColor(patternImage: gradientImage!)
    }
    
    /**
     Creates a radial gradient color.
     - Parameter frame: The frame of the gradient.
     - Parameter colors: An array of `UIColor`'s that will be included in the gradient.
     - Returns: A new radially gradient `UIColor`.
     */
    public class func radialGradientColor(_ frame: CGRect, colors: [UIColor]) -> UIColor? {
        // start the image context
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        
        // get an array of CGColor's from the UIColor's
        let cgColors = colors.map({$0.cgColor})
        
        // init a color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // get a CFArrayRef from our array of CGColor's
        let arrayRef = cgColors as CFArray
        
        // init the gradient
        let gradient = CGGradient(colorsSpace: colorSpace, colors: arrayRef, locations: nil)
        
        // make the center point in the center
        let centrePoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        // calculate the radius from the frame
        let radius = max(frame.size.width, frame.size.height)/2
        
        // draw the radial gradient
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!,
                                     startCenter: centrePoint,
                                     startRadius: 0,
                                     endCenter: centrePoint,
                                     endRadius: radius,
                                     options: .drawsAfterEndLocation)
        
        // get a UIImage from the current context
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // return a new UIColor from the radial gradient we just made
        return UIColor(patternImage: gradientImage!)
    }
}

