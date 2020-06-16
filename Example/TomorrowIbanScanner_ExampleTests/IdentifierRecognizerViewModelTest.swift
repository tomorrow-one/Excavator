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
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)

        // when
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // then
        XCTAssertEqual(self.recognizer.recognizeTextInImageCounter, 1)
    }

    // MARK: - Recognizer in progress

    func testNotInProgressInitially() {
        // given && when
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)

        // then
        XCTAssertEqual(viewModel.inProgess, false)
    }

    func testInProgressIfRecognizerTogglesInProgress() {
        // given
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)

        // when
        self.recognizer.inProgress = true

        // then
        XCTAssertEqual(viewModel.inProgess, true)
    }

    // MARK: - didSuccess

    func testDidSuccess() {
        // given
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didSuccessCounter = 0
        viewModel.didSuccess = { _ in
            didSuccessCounter += 1
        }

        // when
        self.recognizer.invokation(["1"])

        // then
        XCTAssertEqual(didSuccessCounter, 1)
    }

    // MARK: - didRecognizeMultipleResults

    func testCallsDidRecognizeMultipleResults() {
        // given
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        var didRecognizeMultipleResultsCounter = 0
        var actionTitles: [String] = []
        viewModel.didRecognizeMultipleResults = { item in
            didRecognizeMultipleResultsCounter += 1
            actionTitles = item.actions.map { $0.title }
        }

        // when
        self.recognizer.invokation(["1", "2"])

        // then
        XCTAssertEqual(didRecognizeMultipleResultsCounter, 1)
        XCTAssertEqual(actionTitles, ["1", "2", "Cancel"])
    }

    // MARK: - isWaitingForUserInput

    func testInputStopsWhenMultipleValuesRecognized() {
        // given
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        viewModel.didRecognizeMultipleResults = { _ in }

        // when
        self.recognizer.invokation(["1", "2"])
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        // then
        XCTAssertEqual(self.recognizer.recognizeTextInImageCounter, 1)
    }

    func testReceivesInputAgainAfterDidRecognizeMultipleResultsCancelled() {
        // given
        let viewModel = IdentifierRecognizingViewModel(recognizer: self.recognizer)
        viewModel.tryRecognizeIdentifierInImage(self.dummyCiImage)

        viewModel.didRecognizeMultipleResults = { item in
            item.actions[2].action()
        }

        // when
        self.recognizer.invokation(["1", "2"])
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

    var invokation: (([String]) -> Void)!

    private(set) var recognizeTextInImageCounter = 0

    func recognize(_ cgImage: CIImage, completion: @escaping ([String]) -> Void) {
        self.recognizeTextInImageCounter += 1
        self.invokation = completion
    }
}

@available(iOS 13, *)
private final class DummyExtractor: ValueExtracting {

    var extractorValues: [String] = []
    private(set) var counter = 0
    private(set) var receviedResults: [TextRecognizerResult] = []

    func extract(from results: [TextRecognizerResult]) -> [String] {
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
