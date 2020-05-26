//
//  EmailExtractorTest.swift
//  TomorrowIbanScannerTests
//
//  Created by Pavel Stepanov on 23.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import XCTest
import Nimble
@testable import TomorrowIbanScanner

@available(iOS 13, *)
final class EmailExtractorTest: XCTestCase {

    let properEmail = "doggy@doghouse.garden"

    // MARK: - Success

    func testValidEmailExtractionSuccess() {
        // given
        let email = self.properEmail
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(equal(self.properEmail))
    }

    func testValidEmailExtractionHasPrefixSuccess() {
        // given
        let email = "Find my email here ––– \(self.properEmail)"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(equal(self.properEmail))
    }

    func testValidEmailExtractionHasSuffixSuccess() {
        // given
        let email = "\(self.properEmail)ÜÄÖ"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(equal(self.properEmail))
    }

    func testValidEmailExtractionHasSuffixSuccessIWillFailFixMe() {
        // given
        let email = "\(self.properEmail). Also"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(equal(self.properEmail))
    }

    func testEmailExtractionHasPefixAndSuffixSuccess() {
        // given
        let email = "My email: \(self.properEmail). Please send the letter there"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(equal(self.properEmail))
    }

    func testEmailExtractionComplexEmailSuccess() {
        // given
        let email = "one-two-3-all-valid|||{}@banana.com"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(equal(email))
    }

    // MARK: - Failure

    func testEmailWithSpacesExtractionFailure() {
        // given
        let email = "doggy dog @doggyHouse.house"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(beNil())
    }

    func testEmailIncorrectFormatNoSuffixExtractionFailure() {
        // given
        let email = "dog@doggyHouse."
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(beNil())
    }

    func testEmailIncorrectFormatNoPrefixExtractionFailure() {
        // given
        let email = "@doggyHouse.ooo"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(beNil())
    }

    func testEmailIncorrectFormatNoDomainExtractionFailure() {
        // given
        let email = "dog@"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(beNil())
    }

    func testEmailIncorrectFormatNoAtSymbolExtractionFailure() {
        // given
        let email = "dogdoggy.dog.dog"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(beNil())
    }

    func testEmailIncorrectFormatOnlyAtSymbolExtractionFailure() {
        // given
        let email = "@"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        expect(self.extractedEmailValue(from: results)).to(beNil())
    }

    // MARK: - Helpers

    private func extractedEmailValue(from result: [TextRecognizerResult]) -> String? {
        let extractor = EmailExtractor()
        let values = extractor.extract(from: result)
        if case .email(let email) = values.first {
            return email
        } else {
            return nil
        }
    }

    // MARK: - Success, multiple emails

    func testValidMultipleEmailsExtractionSuccess() {
        // given
        let extractor = EmailExtractor()
        let emailValue1 = "dog@doggyHouse.com"
        let emailValue2 = "doggy@dogHouse.com"
        let recognizedValues = [TextRecognizerResult(value: emailValue1, confidence: 1.0),
                                TextRecognizerResult(value: emailValue2, confidence: 1.0)]

        // when
        let extactedValues = extractor.extract(from: recognizedValues)
        let emailValues: [String] = extactedValues.compactMap {
            if case .email(let email) = $0 {
                return email
            } else {
                return nil
            }
        }

        // then
        expect(emailValues).to(equal([emailValue1, emailValue2]))
    }

    func testValidMultipleEmailsOnlyValidExtraction() {
        // given
        let extractor = EmailExtractor()
        let emailValue1 = "123 dog@doggyHouse.com 888"
        let emailValue2 = "I doubt  that is an @ email adress"
        let emailValue3 = "Use  my doggy email: doggy@dogHouse.com . Thanks!"
        let recognizedValues = [TextRecognizerResult(value: emailValue1, confidence: 1.0),
                                TextRecognizerResult(value: emailValue2, confidence: 1.0),
                                TextRecognizerResult(value: emailValue3, confidence: 1.0)]

        // when
        let extactedValues = extractor.extract(from: recognizedValues)
        let emailValues: [String] = extactedValues.compactMap {
            if case .email(let email) = $0 {
                return email
            } else {
                return nil
            }
        }

        // then
        expect(emailValues).to(equal(["dog@doggyHouse.com", "doggy@dogHouse.com"]))
    }
}
