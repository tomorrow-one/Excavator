//
//  IdentifierRecognizingViewModelTest.swift
//  TomorrowIbanScannerTests
//
//  Created by Pavel Stepanov on 16.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import XCTest
@testable import IBScanner
@testable import Example

@available(iOS 13, *)
final class IdentifierRecognizingViewModelTest: XCTestCase {

    private let dummyCiImage = CIImage.empty()
    private var recognizer: DummyTextRecognizer!

    override func setUp() {
        super.setUp()
        self.recognizer = DummyTextRecognizer()
    }

    override func tearDown() {
        super.tearDown()
        self.recognizer = nil
    }

    func testRecognizeImageCallsCount() {
        // given
        let viewModel = IdentifierRecognizingViewModel(extractors: [], recognizer: self.recognizer)

        // when
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // then
        XCTAssertEqual(self.recognizer.recognizeTextInImageCounter, 1)
    }

    // MARK: - Recognizer in progress

    func testNotInProgressInitially() {
        // given && when
        let viewModel = IdentifierRecognizingViewModel(extractors: [], recognizer: self.recognizer)

        // then
        XCTAssertEqual(viewModel.inProgess, false)
    }

    func testInProgressIfRecognizerTogglesInProgress() {
        // given
        let viewModel = IdentifierRecognizingViewModel(extractors: [], recognizer: self.recognizer)

        // when
        self.recognizer.inProgress = true

        // then
        XCTAssertEqual(viewModel.inProgess, true)
    }

    // MARK: - Extractor

    func testExtractorIsCalledEvenIfNoStringsFromRecognizer() {
        // given
        let extractor = DummyExtractor()
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // when
        self.recognizer.invokation([])

        // then
        XCTAssertEqual(extractor.counter, 1)
    }

    func testExtractorCallsCounterForOneStringFromRecognizer() {
        // given
        let extractor = DummyExtractor()
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(extractor.counter, 1)
    }

    func testExtractorCallsCounterForMultipleStringsFromRecognizer() {
        // given
        let extractor = DummyExtractor()
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // when
        let result = [TextRecognizerResult(value: "1", confidence: 1),
                      TextRecognizerResult(value: "2", confidence: 1),
                      TextRecognizerResult(value: "3", confidence: 1)]
        self.recognizer.invokation(result)

        // then
        XCTAssertEqual(extractor.counter, 1)
    }

    func testExtractorReceivesAllStringsFromRecognizer() {
        // given
        let extractor = DummyExtractor()
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // when
        let result = [TextRecognizerResult(value: "1", confidence: 1),
                      TextRecognizerResult(value: "2", confidence: 1),
                      TextRecognizerResult(value: "3", confidence: 1)]
        self.recognizer.invokation(result)

        // then
        XCTAssertEqual(extractor.receviedResults, result)
    }

    func testAllExtractorsGetCalledIfNoSuccess() {
        // given
        let extractor1 = DummyExtractor()
        let extractor2 = DummyExtractor()
        let extractor3 = DummyExtractor()
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor1, extractor2, extractor3], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // when
        let result = [TextRecognizerResult(value: "1", confidence: 1),
                      TextRecognizerResult(value: "2", confidence: 1),
                      TextRecognizerResult(value: "3", confidence: 1)]
        self.recognizer.invokation(result)

        // then
        XCTAssertEqual(extractor1.counter, 1)
        XCTAssertEqual(extractor2.counter, 1)
        XCTAssertEqual(extractor3.counter, 1)
    }

    func testAllExtractorsGetCalledIfSuccess() {
        // given
        let extractor1 = DummyExtractor()
        let extractor2 = DummyExtractor()
        extractor2.extractorValues = [.iban(iban: IBScanner.Iban(value: "DE75110101002144403897"))]
        let extractor3 = DummyExtractor()
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor1, extractor2, extractor3], recognizer: self.recognizer)
        viewModel.didSuccess = { _ in }
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // when
        let result = [TextRecognizerResult(value: "1", confidence: 1),
                      TextRecognizerResult(value: "2", confidence: 1),
                      TextRecognizerResult(value: "3", confidence: 1)]
        self.recognizer.invokation(result)

        // then
        XCTAssertEqual(extractor1.counter, 1)
        XCTAssertEqual(extractor2.counter, 1)
        XCTAssertEqual(extractor3.counter, 1)
    }

    // MARK: - didSuccess

    func testDidSuccessExtractorExtractedIban() {
        // given
        let extractor = DummyExtractor()
        extractor.extractorValues = [.iban(iban: IBScanner.Iban(value: StubModel.validIban.value))]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didSuccessCounter = 0
        viewModel.didSuccess = { _ in
            didSuccessCounter += 1
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(didSuccessCounter, 1)
    }

    func testDidSuccessExtractorExtractedEmail() {
        // given
        let extractor = DummyExtractor()
        extractor.extractorValues = [.email(email: "du@tomorrow.one")]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didSuccessCounter = 0
        viewModel.didSuccess = { _ in
            didSuccessCounter += 1
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(didSuccessCounter, 1)
    }

    func testNoDidSuccessExtractorNotExtracted() {
        // given
        let extractor = DummyExtractor()
        extractor.extractorValues = []
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didSuccessCounter = 0
        viewModel.didSuccess = { _ in
            didSuccessCounter += 1
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(didSuccessCounter, 0)
    }

    // MARK: - didRecognizeMultipleResults

    func testCallsDidRecognizeMultipleResultsIfMultipleEmailValues() {
        // given
        let extractor = DummyExtractor()
        extractor.extractorValues = [.email(email: "du@tomorrow.one"), .email(email: "wir@tomorrow.one")]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didRecognizeMultipleResultsCounter = 0
        var actionTitles: [String] = []
        viewModel.didRecognizeMultipleResults = { item in
            didRecognizeMultipleResultsCounter += 1
            actionTitles = item.actions.map { $0.title }
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(didRecognizeMultipleResultsCounter, 1)
        XCTAssertEqual(actionTitles, ["du@tomorrow.one", "wir@tomorrow.one", "Cancel"])
    }

    func testCallsDidRecognizeMultipleResultsIfMultipleIbanValues() {
        // given
        let extractor = DummyExtractor()
        let iban1 = StubModel.validIban
        let iban2 = StubModel.validIban2
        extractor.extractorValues = [.iban(iban: IBScanner.Iban(value: StubModel.validIban.value)),
                                     .iban(iban: IBScanner.Iban(value: StubModel.validIban2.value))]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didRecognizeMultipleResultsCounter = 0
        var actionTitles: [String] = []
        viewModel.didRecognizeMultipleResults = { item in
            didRecognizeMultipleResultsCounter += 1
            actionTitles = item.actions.map { $0.title }
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(didRecognizeMultipleResultsCounter, 1)
        XCTAssertEqual(actionTitles, [iban1.value, iban2.value, "Cancel"])
    }

    func testCallsDidRecognizeMultipleResultsIfEmailAndIbanValues() {
        // given
        let ibanExtractor = DummyExtractor()
        let emailExtractor = DummyExtractor()
        let iban = StubModel.validIban
        let email = "ihr@tomorrow.one"
        ibanExtractor.extractorValues = [.iban(iban: IBScanner.Iban(value: StubModel.validIban.value))]
        emailExtractor.extractorValues = [.email(email: email)]
        let viewModel = IdentifierRecognizingViewModel(extractors: [ibanExtractor, emailExtractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didRecognizeMultipleResultsCounter = 0
        var actionTitles: [String] = []
        viewModel.didRecognizeMultipleResults = { item in
            didRecognizeMultipleResultsCounter += 1
            actionTitles = item.actions.map { $0.title }
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        XCTAssertEqual(didRecognizeMultipleResultsCounter, 1)
        XCTAssertEqual(actionTitles, [iban.value, email, "Cancel"])
    }

    func testDidSuccessAfterDidRecognizeMultipleResults() {
        // given
        let extractor = DummyExtractor()
        let iban = IBScanner.Iban(value: StubModel.validIban.value)
        let email = "ihr@tomorrow.one"
        extractor.extractorValues = [.iban(iban: iban), .email(email: email)]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        viewModel.didRecognizeMultipleResults = { item in
            item.actions[1].action()
        }

        var extractedValue: ExtractorValue?
        viewModel.didSuccess = { value in
            extractedValue = value
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])

        // then
        guard case .email(let extractedEmail) = extractedValue else {
            XCTFail("Incorrect state")
            return
        }

        XCTAssertEqual(extractedEmail, email)
    }

    // MARK: - isWaitingForUserInput

    func testInputStopsWhenMultipleValuesRecognized() {
        // given
        let extractor = DummyExtractor()
        extractor.extractorValues = [.email(email: "du@tomorrow.one"), .email(email: "wir@tomorrow.one")]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        viewModel.didRecognizeMultipleResults = { _ in }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // then
        XCTAssertEqual(self.recognizer.recognizeTextInImageCounter, 1)
    }

    func testReceivesInputAgainAfterDidRecognizeMultipleResultsCancelled() {
        // given
        let extractor = DummyExtractor()
        let iban = IBScanner.Iban(value: StubModel.validIban.value)
        let email = "ihr@tomorrow.one"
        extractor.extractorValues = [.iban(iban: iban), .email(email: email)]
        let viewModel = IdentifierRecognizingViewModel(extractors: [extractor], recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        viewModel.didRecognizeMultipleResults = { item in
            item.actions[2].action()
        }

        // when
        self.recognizer.invokation([TextRecognizerResult(value: "1", confidence: 1)])
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // then
        XCTAssertEqual(self.recognizer.recognizeTextInImageCounter, 4)
    }
}

@available(iOS 13, *)
private class DummyTextRecognizer: TextRecognizing {

    var inProgress = false

    var invokation: (([TextRecognizerResult]) -> Void)!

    private(set) var recognizeTextInImageCounter = 0

    func recognizeTextInImage(_ ciImage: CIImage, completion: @escaping (([TextRecognizerResult]) -> Void)) {
        self.recognizeTextInImageCounter += 1
        self.invokation = completion
    }
}

@available(iOS 13, *)
private final class DummyExtractor: ValueExtracting {

    var extractorValues: [ExtractorValue] = []
    private(set) var counter = 0
    private(set) var receviedResults: [TextRecognizerResult] = []

    func extract(from results: [TextRecognizerResult]) -> [ExtractorValue] {
        self.counter += 1
        self.receviedResults.append(contentsOf: results)
        return self.extractorValues
    }
}

@available(iOS 13, *)
extension TextRecognizerResult: Equatable {
    public static func == (lhs: TextRecognizerResult, rhs: TextRecognizerResult) -> Bool {
        lhs.value == rhs.value && lhs.confidence == rhs.confidence
    }
}
