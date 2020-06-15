//
//  IdentifierRecognizingViewModel.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 31.03.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import UIKit
import IBScanner

final class IdentifierRecognizingViewModel {

    var inProgess: Bool {
        self.recognizer.inProgress
    }

    var didSuccess: ((ExtractorValue) -> Void)!
    var didRecognizeMultipleResults: ((AlertControllerViewItem) -> Void)!

    private var isWaitingForUserInput = false

    private let recognizer: TextRecognizing
    private let extractors: [ValueExtracting]

    init(extractors: [ValueExtracting], recognizer: TextRecognizing = TextRecognizer()) {
        self.recognizer = recognizer
        self.extractors = extractors
    }

    func tryRecognizeIdentifierInImage(_ ciImage: CIImage) {
        guard !self.isWaitingForUserInput else {
            return
        }
        self.recognizer.recognizeTextInImage(ciImage) { [weak self] results in
            self?.recognizeResults(results)
        }
    }

    private func recognizeResults(_ results: [TextRecognizerResult]) {
        let extractorResults = self.extractors.flatMap { $0.extract(from: results) }
        if extractorResults.count == 1 {
            self.didSuccess(extractorResults.first!)
        } else if extractorResults.count > 1 {
            let controllerItem = makeAlertControllerItem(for: extractorResults)
            self.didRecognizeMultipleResults(controllerItem)
        }
    }

    private func makeAlertControllerItem(for extractorResults: [ExtractorValue]) -> AlertControllerViewItem {
        self.isWaitingForUserInput = true
        var actions = extractorResults.map { extractorResult in
            AlertActionViewItem(title: self.title(for: extractorResult), style: .default(isPreferred: false)) { [unowned self] in
                self.didSuccess(extractorResult)
            }
        }

        actions.append(AlertActionViewItem(title: "Cancel", style: .cancel) { [unowned self] in
            self.isWaitingForUserInput = false
        })

        return AlertControllerViewItem(title: "We have found multiple IBANs or emails", message: "Select one", actions: actions)
    }

    private func title(for extractorResult: ExtractorValue) -> String {
        switch extractorResult {
        case .email(let email):
            return email
        case .iban(let iban):
            return iban.value
        }
    }
}
