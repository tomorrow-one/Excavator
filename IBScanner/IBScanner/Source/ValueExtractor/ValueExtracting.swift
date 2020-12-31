//
//  ValueExtracting.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public protocol ValueExtracting {
    func extract(from input: [TextRecognizer.Result]) -> [String]
}
