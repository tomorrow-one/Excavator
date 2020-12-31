//
//  TextRecognizerResult.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 23.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)

extension TextRecognizer {
    public struct Result {
        public let value: String
        public let confidence: Float
    }
}
