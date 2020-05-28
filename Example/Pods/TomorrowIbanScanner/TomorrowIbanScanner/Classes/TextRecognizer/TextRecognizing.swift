//
//  TextRecognizing.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 21.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import CoreImage.CIImage

@available(iOS 13, *)
public protocol TextRecognizing: class {
    var inProgress: Bool { get set }
    func recognizeTextInImage(_ cgImage: CIImage, completion: @escaping ([TextRecognizerResult]) -> Void)
}
