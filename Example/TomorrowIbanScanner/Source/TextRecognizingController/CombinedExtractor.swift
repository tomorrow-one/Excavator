//
//  CombinedExtractor.swift
//  Example
//
//  Created by Pavel Stepanov on 16.06.20.
//  Copyright © 2020 Tomorrow. All rights reserved.
//

import IBScanner

final class CombinedExtractor: ValueExtracting {

    private let emailExtractor = EmailExtractor()
    private let ibanExtractor = IbanExtractor()

    func extract(from results: [TextRecognizerResult]) -> [String] {
        return self.emailExtractor.extract(from: results) + self.ibanExtractor.extract(from: results)
    }
}
