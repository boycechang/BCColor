![BCColor](https://github.com/boycechang/BCColor/blob/master/icon.png)

#BCColor
**A lightweight but powerful color kit (Swift)**



## Features

- Pick Colors From Image

- Generate Monochrome Image

- Support Hex Color Style

- Lighten / Darken Any Color

- Generate Two Different Styles of Gradient Color

  ​

  ![BCColor](https://github.com/boycechang/BCColor/blob/master/demo1.jpeg)

  ![BCColor](https://github.com/boycechang/BCColor/blob/master/demo2.jpeg)

  ![BCColor](https://github.com/boycechang/BCColor/blob/master/demo3.jpeg)

  ​

  ​



## Installation

#### Requirements

* ARC only; iOS 8.0+

  ​

#### Get it as: 
##### 1) source files

1. Download the BCColor repository as a zip file or clone it
2. Copy the BCColor files into your Xcode project

##### 2) via Cocoa pods

BCColor is available on [CocoaPods](http://cocoapods.org). Just add the following to your project Podfile:

```ruby
pod 'BCColor'
```

If you want to read more about CocoaPods, have a look at [this short tutorial](http://www.raywenderlich.com/12139/introduction-to-cocoapods).



## Basic Usage

```swift
// Pick Colors From Image
let colors = image?.getColors()

// Generate Momochrome Image
let monochromeImage = image?.monochrome()

// Hex Color
UIColor.colorWithHex("#5d13e2", alpha: 1)

// Gradient Color
UIColor.gradientColor(CGPointMake(0.0, 0.0), endPoint: CGPointMake(1.0, 1.0), frame:frame, colors: [UIColor.redColor(), UIColor.blueColor()])

UIColor.radialGradientColor(frame, colors: [UIColor.blueColor(), UIColor.greenColor()])
```



##Misc

Author: [Boyce Chang](http://www.boycechang.com)

If you like BCColor and use it, could you please:

* star this repo 
* send me some feedback. Thanks!


#### License
This code is distributed under the terms and conditions of the MIT license. 


#### Contribution guidelines
If you are fixing a bug you discovered, please add also a unit test so I know how exactly to reproduce the bug before merging.
