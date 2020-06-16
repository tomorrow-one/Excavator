//
//  IbanExtractor.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public final class IbanExtractor: ValueExtracting {

    private let ibanInStringRegex = "[A-Z]{2}\\d{2}[A-Z\\d]+"
    private let ibanMandatoryPrefixLength = 4

    public init() { }

    public func extract(from results: [TextRecognizerResult]) -> [String] {
        let concatenetedValue: String = results.reduce("") { $0 + $1.value }
        return process(recognitionResult: TextRecognizerResult(value: concatenetedValue, confidence: 1.0))
    }

    private func process(recognitionResult: TextRecognizerResult) -> [String] {
        let trimmedIbanValue = IbanHelper.trimNonValidCharacters(from: recognitionResult.value.uppercased())
        let possibleIbanValues = extractPossibleIbans(from: trimmedIbanValue, isFirstStep: true)

        var extractedIbans: [String] = []
        for possibleIbanValue in possibleIbanValues {
            if let iban = excerptIban(with: possibleIbanValue) {
                extractedIbans.append(iban)
            }
        }
        return extractedIbans
    }

    private func extractPossibleIbans(from string: String, isFirstStep: Bool) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: self.ibanInStringRegex) else {
            return []
        }
        let nsString = string as NSString
        let location = isFirstStep ? 0 : self.ibanMandatoryPrefixLength
        let matches = regex.matches(in: string, range: NSRange(location: location, length: string.count - location))
        var result = matches.compactMap { nsString.substring(with: $0.range) }
        result.append(contentsOf: result.flatMap { extractPossibleIbans(from: $0, isFirstStep: false) })
        return result
    }

    private func excerptIban(with possibleIbanValue: String) -> String? {
        var currentLength = IbanHelper.minIbanLength
        while currentLength <= possibleIbanValue.count {
            let probableIban = String(possibleIbanValue.prefix(currentLength))
            if let iban = IbanHelper.excerpt(from: probableIban) {
                return iban
            }

            currentLength += 1
        }
        return nil
    }
}
