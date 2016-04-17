//
//  UIImage+BCColor.swift
//  BCColor
//
//  Created by Boyce on 3/21/16.
//  Copyright © 2016 Boyce. All rights reserved.
//

import UIKit

/// `BCImageColors` can be used to contain many properties of image colors.
public struct BCImageColors {
    /// The background color.
    public var backgroundColor: UIColor!
    
    /// The primary color.
    public var primaryColor: UIColor!
    
    /// The secondary color.
    public var secondaryColor: UIColor!
    
    /// The minor color.
    public var minorColor: UIColor!
}

private class BCCountedColor {
    let color: UIColor
    let count: Int
    
    init(color: UIColor, count: Int) {
        self.color = color
        self.count = count
    }
}

extension UIImage {
    
    /**
     Resizes the image to a `newSize`.
     - Parameter newSize: The size to resize the image to.
     - Returns: A new `UIImage` that has been resized.
     */
    public func resize(newSize: CGSize) -> UIImage {
        // start a context
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        
        // draw the image in the context
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        // get the image from the context
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the context
        UIGraphicsEndImageContext()
        
        // return the new UIImage
        return result
    }
    
    /**
     Gets the colors of the image.
     - Returns: A `BCImageColors` object.
     */
    public func getColors() -> BCImageColors {
        //
        var result = BCImageColors()
        
        // get the ratio of width to height
        let ratio = self.size.width/self.size.height
        
        // calculate new r_width and r_height
        let r_width: CGFloat = 100
        let r_height: CGFloat = r_width/ratio
        
        // resize the image to the new r_width and r_height
        let cgImage = self.resize(CGSizeMake(r_width, r_height)).CGImage
        
        // get the width and height of the new image
        let width = CGImageGetWidth(cgImage)
        let height = CGImageGetHeight(cgImage)
        
        // get the colors from the image
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = width * bytesPerPixel
        let bitsPerComponent: Int = 8
        let sortedColorComparator: NSComparator = { (main, other) -> NSComparisonResult in
            let m = main as! BCCountedColor, o = other as! BCCountedColor
            if m.count < o.count {
                return NSComparisonResult.OrderedDescending
            } else if m.count == o.count {
                return NSComparisonResult.OrderedSame
            } else {
                return NSComparisonResult.OrderedAscending
            }
        }
        
        // get black and white colors
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        // color detection
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)
        let bitmapInfo = CGImageAlphaInfo.PremultipliedFirst.rawValue
        let ctx = CGBitmapContextCreate(raw, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)
        CGContextDrawImage(ctx, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), cgImage)
        let data = UnsafePointer<UInt8>(CGBitmapContextGetData(ctx))
        let imageColors = NSCountedSet(capacity: width * height)
        
        // color detection
        for x in 0..<width {
            for y in 0..<height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    red: round(CGFloat(data[pixel + 1]) / 255 * 120) / 120,
                    green: round(CGFloat(data[pixel + 2]) / 255 * 120) / 120,
                    blue: round(CGFloat(data[pixel + 3]) / 255 * 120) / 120,
                    alpha: 1
                )
                
                imageColors.addObject(color)
            }
        }
        free(raw)
        
        // preprocess and filter colors that appear seldomly or close to black or white
        let enumerator = imageColors.objectEnumerator()
        let sortedColors = NSMutableArray(capacity: imageColors.count)
        while let kolor = enumerator.nextObject() as? UIColor {
            let colorCount = imageColors.countForObject(kolor)
            if 3 < colorCount && !kolor.isBlackOrWhite {
                sortedColors.addObject(BCCountedColor(color: kolor, count: colorCount))
            }
        }
        sortedColors.sortUsingComparator(sortedColorComparator)
        
        // get the background colour
        var backgroundColor: BCCountedColor
        if 0 < sortedColors.count {
            backgroundColor = sortedColors.objectAtIndex(0) as! BCCountedColor
        } else {
            backgroundColor = BCCountedColor(color: blackColor, count: 1)
        }
        result.backgroundColor = backgroundColor.color
        
        // create theme colors, contrast theme color with background color in lightness, and select cognizable chromatic aberration among theme colors
        let isDarkBackgound = result.backgroundColor.isDark
        for curContainer in sortedColors {
            let kolor = (curContainer as! BCCountedColor).color
            if (kolor.isDark && isDarkBackgound) || (!kolor.isDark && !isDarkBackgound) {continue}
            
            if result.primaryColor == nil {
                if kolor.isContrasting(result.backgroundColor) {
                    result.primaryColor = kolor
                }
            } else if result.secondaryColor == nil {
                if result.primaryColor.isDistinct(kolor) && kolor.isContrasting(result.backgroundColor) {
                    result.secondaryColor = kolor
                }
            } else if result.minorColor == nil {
                if result.secondaryColor.isDistinct(kolor) && result.primaryColor.isDistinct(kolor) && kolor.isContrasting(result.backgroundColor) {
                    result.minorColor = kolor
                    break
                }
            }
        }
        
        // set the colors if there is none set for the three colors
        
        if result.primaryColor == nil {
            result.primaryColor = isDarkBackgound ? whiteColor:blackColor
        }
        
        if result.secondaryColor == nil {
            result.secondaryColor = isDarkBackgound ? whiteColor:blackColor
        }
        
        if result.minorColor == nil {
            result.minorColor = isDarkBackgound ? whiteColor:blackColor
        }
        
        // return the result
        return result
    }
    
    /**
     Generates a `monochrome` image.
     - Returns: A new `UIImage` that is `monochrome`.
     */
    public func monochrome() -> UIImage {
        // get the original CIImage
        let originalImage = CoreImage.CIImage(image: self)
        
        // apply the CIPhotoEffectMono filter to the image
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter!.setDefaults()
        filter!.setValue(originalImage, forKey: kCIInputImageKey)
        
        // get the output image
        let outputImage = filter!.outputImage
        
        // return a new UIImage from the CIImage the filter has been applied to
        return UIImage(CIImage: outputImage!)
    }
}
