# Excavator

![Cocoapods](https://img.shields.io/cocoapods/v/Excavator)
![Cocoapods](https://img.shields.io/cocoapods/l/Excavator)
![Cocoapods platforms](https://img.shields.io/cocoapods/p/Excavator)

## Requirements
- iOS 13.0+
- Xcode 11+
- Swift 5.1+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Excavator into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby
pod 'Excavator'
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

## Example
<img src="https://github.com/tomorrow-one/Excavator/blob/master/Excavator/Screenshots/EmailExample.PNG" width="200"> <img src="https://github.com/tomorrow-one/Excavator/blob/master/Excavator/Screenshots/MultilineExample.PNG" width="200"> <img src="https://github.com/tomorrow-one/Excavator/blob/master/Excavator/Screenshots/MultipleIdsExample.PNG" width="200">

## License

Excavator is available under the MIT license. See the LICENSE file for more info.
