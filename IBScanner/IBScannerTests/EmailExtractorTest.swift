//
//  EmailExtractorTest.swift
//  TomorrowIbanScannerTests
//
//  Created by Pavel Stepanov on 23.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import XCTest
@testable import IBScanner

@available(iOS 13, *)
final class EmailExtractorTest: XCTestCase {

    let properEmail = "doggy@doghouse.garden"

    // MARK: - Success

    func testValidEmailExtractionSuccess() {
        // given
        let email = self.properEmail
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), self.properEmail)
    }

    func testValidEmailExtractionHasPrefixSuccess() {
        // given
        let email = "Find my email here ––– \(self.properEmail)"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), self.properEmail)
    }

    func testValidEmailExtractionHasSuffixSuccess() {
        // given
        let email = "\(self.properEmail)ÜÄÖ"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), self.properEmail)
    }

    func testValidEmailExtractionHasSuffixSuccessIWillFailFixMe() {
        // given
        let email = "\(self.properEmail). Also"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), self.properEmail)
    }

    func testEmailExtractionHasPefixAndSuffixSuccess() {
        // given
        let email = "My email: \(self.properEmail). Please send the letter there"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), self.properEmail)
    }

    func testEmailExtractionComplexEmailSuccess() {
        // given
        let email = "one-two-3-all-valid|||{}@banana.com"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), email)
    }

    // MARK: - Failure

    func testEmailWithSpacesExtractionFailure() {
        // given
        let email = "doggy dog @doggyHouse.house"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), nil)
    }

    func testEmailIncorrectFormatNoSuffixExtractionFailure() {
        // given
        let email = "dog@doggyHouse."
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), nil)
    }

    func testEmailIncorrectFormatNoPrefixExtractionFailure() {
        // given
        let email = "@doggyHouse.ooo"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), nil)
    }

    func testEmailIncorrectFormatNoDomainExtractionFailure() {
        // given
        let email = "dog@"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), nil)
    }

    func testEmailIncorrectFormatNoAtSymbolExtractionFailure() {
        // given
        let email = "dogdoggy.dog.dog"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), nil)
    }

    func testEmailIncorrectFormatOnlyAtSymbolExtractionFailure() {
        // given
        let email = "@"
        let results = [TextRecognizerResult(value: email, confidence: 1.0)]

        // when && then
        XCTAssertEqual(extractedEmailValue(from: results), nil)
    }

    // MARK: - Helpers

    private func extractedEmailValue(from result: [TextRecognizerResult]) -> String? {
        let extractor = EmailExtractor()
        let values = extractor.extract(from: result)
        return values.first
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
        let emailValues: [String] = extactedValues.compactMap { $0 }

        // then
        XCTAssertEqual(emailValues, [emailValue1, emailValue2])
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
        let emailValues: [String] = extactedValues.compactMap { $0 }

        // then
        XCTAssertEqual(emailValues, ["dog@doggyHouse.com", "doggy@dogHouse.com"])
    }
}
