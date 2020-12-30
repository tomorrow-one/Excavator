# TomorrowIbanScanner

[![Version](https://img.shields.io/cocoapods/v/TomorrowIbanScanner.svg?style=flat)](https://cocoapods.org/pods/TomorrowIbanScanner)
[![License](https://img.shields.io/cocoapods/l/TomorrowIbanScanner.svg?style=flat)](https://cocoapods.org/pods/TomorrowIbanScanner)
[![Platform](https://img.shields.io/cocoapods/p/TomorrowIbanScanner.svg?style=flat)](https://cocoapods.org/pods/TomorrowIbanScanner)

## Requirements
- iOS 13.0+
- Xcode 11+
- Swift 5.1+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate TomorrowIbanScanner into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby
pod 'TomorrowIbanScanner'
```

## Features
- [x] extract content from an image;
- [x] supported content types: IBAN, email;
- [x] all occurances are recognized;

## Usage

```swift
let recognizer = TextRecognizer(extractor: IbanExtractor())
let ciImage = cameraImage()
recognizer.recognize(in: ciImage) { ibans in
    // do something here
}
```

For the complete flow, please refer to the Example project.

### Configuration
As for now the library logs errors if any were produced into the standart output. You can switch it off with 
`TextRecognizer.Config.isDebugLoggingEnabled = false`

## Examples

<img src="https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner/blob/master/Screenshots/EmailExample.PNG" width="200"> <img src="https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner/blob/master/Screenshots/MultilineExample.PNG" width="200"> <img src="https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner/blob/master/Screenshots/MultipleIdsExample.PNG" width="200">

## License

TomorrowIbanScanner is available under the MIT license. See the LICENSE file for more info.
