//
//  IbanExtractor.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public final class IbanExtractor: ValueExtracting {

    private let prefixRegex = try! NSRegularExpression(pattern: "[A-Z]{2}\\d{2}[A-Z\\d]+")
    private let minPrefixLength = 4

    public init() { }

    public func extract(from input: [TextRecognizer.Result]) -> [String] {
        let normalizedInput = input
            .map { $0.value.uppercased() }
            .map(trimNonValidCharacters(from:))
            .joined()
        return possibleSequences(in: normalizedInput)
            .compactMap(excerptIban(from:))
    }

    private func possibleSequences(in string: String) -> [String] {
        guard !string.isEmpty else {
            return []
        }
        let matches = self.prefixRegex.matches(in: string, range: NSRange(location: 0, length: string.count))
        let nsString = string as NSString
        let baseResults = matches.compactMap { nsString.substring(with: $0.range) }
        let subResults = baseResults
            .map { String($0.dropFirst(self.minPrefixLength)) }
            .flatMap(possibleSequences(in:))
        return baseResults + subResults
    }

    private func excerptIban(from value: String) -> String? {
        let prefix = String(value.prefix(2))
        guard let iso = CountryIso(rawValue: prefix), let length = IbanValidator.length(for: iso) else {
            return nil
        }

        let iban = String(value.prefix(length))
        return IbanValidator.isValid(iban: iban) ? iban : nil
    }

    private func trimNonValidCharacters(from string: String) -> String {
        string.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
    }
}
