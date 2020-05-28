# TomorrowIbanScanner

[![CI Status](https://img.shields.io/travis/PavelStepanovTomorrow/TomorrowIbanScanner.svg?style=flat)](https://travis-ci.org/PavelStepanovTomorrow/TomorrowIbanScanner)
[![Version](https://img.shields.io/cocoapods/v/TomorrowIbanScanner.svg?style=flat)](https://cocoapods.org/pods/TomorrowIbanScanner)
[![License](https://img.shields.io/cocoapods/l/TomorrowIbanScanner.svg?style=flat)](https://cocoapods.org/pods/TomorrowIbanScanner)
[![Platform](https://img.shields.io/cocoapods/p/TomorrowIbanScanner.svg?style=flat)](https://cocoapods.org/pods/TomorrowIbanScanner)

## Requirements
iOS 13+. As Vision framework recognizes text only starting from iOS 13.

## Installation

TomorrowIbanScanner is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TomorrowIbanScanner'
```

## Usage

Workflow is the following:

0. Create instances of `TextRecognizer` and needed extractors. E.g. `IbanExtractor`
1. Get a `CIImage` which needs recognition e.g. from camera
2. Call `func recognizeTextInImage(_ ciImage: CIImage, completion: @escaping ([TextRecognizerResult]) -> Void)`
3. With the results from the completion of the previous function call `func extract(from results: [TextRecognizerResult]) -> [ExtractorValue]`
4. Grab the extracted `[TextRecognizerResult]` and use it for the greater good ☀️

For the complete flow, please refer to the Example project. It has the implementation we used in Tomorrow.

As for now the library logs errors if any were produced into the standart output. You can switch it off with 
`TextRecognizerConfig.isDebugLoggingEnabled = false`

## Features

- Recognize IBAN (including multiline IBANs)
- Recognize email

## Example

In the example project you can see a fully set up flow where we can extract IBAN, email or even multiple entries and then choose one.

<img src="https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner/blob/master/Example/TomorrowIbanScanner/Screenshots/EmailExample.PNG" width="200"> <img src="https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner/blob/master/Example/TomorrowIbanScanner/Screenshots/MultilineExample.PNG" width="200"> <img src="https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner/blob/master/Example/TomorrowIbanScanner/Screenshots/MultipleIdsExample.PNG" width="200">

## License

TomorrowIbanScanner is available under the MIT license. See the LICENSE file for more info.
