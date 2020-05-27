//
//  TextRecognizerResult.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 23.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public struct TextRecognizerResult {
    public let value: String
    public let confidence: Float
}
