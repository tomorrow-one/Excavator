//
//  IbanExtractorTest.swift
//  TomorrowIbanScannerTests
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import XCTest
import Nimble
@testable import TomorrowIbanScanner

@available(iOS 13, *)
final class IbanExtractorTest: XCTestCase {

    // MARK: - Success, one IBAN value

    private let properIbanValue = "DE87110101002430920438"

    func testValidIbanExtractionSuccess() {
        // given
        let ibanValue = properIbanValue
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithSpacesOnEndsExtractionSuccess() {
        // given
        let ibanValue = " DE87110101002430920438 "
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithSpacesExtractionSuccess() {
        // given
        let ibanValue = "DE87 1101 0100 2430 9204 38"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithNonBreakableSpacesExtractionSuccess() {
        // given
        let ibanValue = "DE87 1101 0100 2430 9204 38"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithIncorrectSymbolsOnEndsExtractionSuccess() {
        // given
        let ibanValue = "?DE87110101002430920438ü"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanLowercasedExtractionSuccess() {
        // given
        let ibanValue = "?de87110101002430920438"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithIncorrectPrefixExtractionSuccess() {
        // given
        let ibanValue = "WrongStart DE87110101002430920438"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithIncorrectSuffixExtractionSuccess() {
        // given
        let ibanValue = "DE87110101002430920438 WrongEnd"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithFalseyIbanPrefixExtractionSuccess() {
        // given
        let ibanValue = "DE87 DE87110101002430920438"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithFalseyIbanPrefixAndSuffixExtractionSuccess() {
        // given
        let ibanValue = "DE87DE87110101002430920438De87871101"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(properIbanValue))
    }

    func testValidIbanWithLineEndExtractionSuccess() {
        // given
        let ibanValue = "DE61110101002562351444\n"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal("DE61110101002562351444"))
    }

    func testValidIbanExtractionWithOtherValidIbanInSubstring() {
        // given
        let ibanValue = "MC9114508000702484513283C60"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal("MC9114508000702484513283C60"))
    }

    func testIValidIbanExtractionWithOtherValidNonExistingIban() {
        // given
        let ibanValue = "MARKDEF1700 DE05700000000070001506"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal("DE05700000000070001506"))
    }

    // MARK: - No success

    func testInvalidIbanExtractionNil() {
        // given
        let ibanValue = "DE61110 Bad bad iban 101002562351444\n"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 1.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(beNil())
    }

    func testSuccessEvenWithoutConfidence() {
        // given
        let ibanValue = "DE61110101002562351444"
        let recognizedValue = TextRecognizerResult(value: ibanValue, confidence: 0.0)

        // when && then
        expect(self.extractedIbanValue(from: [recognizedValue])).to(equal(ibanValue))
    }

    // MARK: - Helper

    private func extractedIbanValue(from result: [TextRecognizerResult]) -> String? {
        let extractor = IbanExtractor()
        let values = extractor.extract(from: result)
        if case .iban(let iban) = values.first {
            return iban.value
        } else {
            return nil
        }
    }

    // MARK: - Success, multiple IBANs

    func testValidMultipleIbansExtractionSuccess() {
        // given
        let extractor = IbanExtractor()
        let ibanValue1 = "?de87110101002430920438"
        let ibanValue2 = "MARKDEF1700 DE05700000000070001506"
        let recognizedValues = [TextRecognizerResult(value: ibanValue1, confidence: 1.0),
                                TextRecognizerResult(value: ibanValue2, confidence: 1.0)]

        // when
        let extactedValues = extractor.extract(from: recognizedValues)
        let ibanValues: [String] = extactedValues.compactMap {
            if case .iban(let iban) = $0 {
                return iban.value
            } else {
                return nil
            }
        }

        // then
        expect(ibanValues).to(equal(["DE87110101002430920438", "DE05700000000070001506"]))
    }

    func testMultipleIbansOnlyValidExtracted() {
        // given
        let extractor = IbanExtractor()
        let ibanValue1 = "?de87110101002430920438"
        let ibanValue2 = "Really wrong iban value"
        let ibanValue3 = "MARKDEF1700 DE05700000000070001506"
        let ibanValue4 = "doggy@doghouse.dog"
        let recognizedValues = [TextRecognizerResult(value: ibanValue1, confidence: 1.0),
                                TextRecognizerResult(value: ibanValue2, confidence: 1.0),
                                TextRecognizerResult(value: ibanValue3, confidence: 1.0),
                                TextRecognizerResult(value: ibanValue4, confidence: 1.0)]

        // when
        let extactedValues = extractor.extract(from: recognizedValues)
        let ibanValues: [String] = extactedValues.compactMap {
            if case .iban(let iban) = $0 {
                return iban.value
            } else {
                return nil
            }
        }

        // then
        expect(ibanValues).to(equal(["DE87110101002430920438", "DE05700000000070001506"]))
    }

    func testMultipleIbansInOneLineAllExtracted() {
        // given
        let extractor = IbanExtractor()
        let ibanValue1 = "de87110101002430920438"
        let ibanValue2 = "DE05700000000070001506"
        let totalIbanValue = ibanValue1 + "some useless letters" + ibanValue2
        let recognizedValues = [TextRecognizerResult(value: totalIbanValue, confidence: 1.0)]

        // when
        let extactedValues = extractor.extract(from: recognizedValues)
        let ibanValues: [String] = extactedValues.compactMap {
            if case .iban(let iban) = $0 {
                return iban.value
            } else {
                return nil
            }
        }

        // then
        expect(ibanValues).to(equal(["DE87110101002430920438", "DE05700000000070001506"]))
    }
}
