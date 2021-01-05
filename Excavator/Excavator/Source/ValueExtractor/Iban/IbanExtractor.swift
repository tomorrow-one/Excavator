//
//  IbanExtractor.swift
//  Excavator
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import Foundation

@available(iOS 13, *)
public final class IbanExtractor: ValueExtracting {

    private let minPrefixLength = 4
    private lazy var minSuffixLength = IbanValidator.minLength - self.minPrefixLength
    private lazy var maxSuffixLength = IbanValidator.maxLength - self.minPrefixLength
    private lazy var possibleIbanRegex = try! NSRegularExpression(pattern: "[A-Z]{2}\\d{2}[A-Z\\d]{\(self.minSuffixLength),\(self.maxSuffixLength)}")


    public init() { }

    public func extract(from input: [TextRecognizer.Result]) -> [String] {
        let normalizedInput = input
            .map { $0.value.uppercased() }
            .map { $0.replacingOccurrences(of: " ", with: "") }
            .joined()
        return excerptIbans(from: normalizedInput)
    }

    private func excerptIbans(from input: String) -> [String] {
        var result = [String]()
        let inputLength = input.count
        let nsString = input as NSString
        var location = 0
        while let match = self.possibleIbanRegex.firstMatch(in: input, range: NSRange(location: location, length: inputLength - location)) {
            location = match.range.location + self.minPrefixLength
            let possibleIban = nsString.substring(with: match.range)
            let prefix = String(possibleIban.prefix(2))
            guard let iso = CountryIso(rawValue: prefix), let length = IbanValidator.length(for: iso) else {
                continue
            }
            let iban = String(possibleIban.prefix(length))
            if IbanValidator.isValid(iban: iban) {
                result.append(iban)
                location = match.range.location + length
            }
        }

        return result
    }
}
