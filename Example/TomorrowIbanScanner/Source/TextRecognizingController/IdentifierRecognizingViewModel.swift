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

    var didSuccess: ((String) -> Void)!
    var didRecognizeMultipleResults: ((AlertControllerViewItem) -> Void)!

    private var isWaitingForUserInput = false

    private let recognizer: TextRecognizing

    init(recognizer: TextRecognizing) {
        self.recognizer = recognizer
    }

    func tryRecognizeIdentifierInImage(_ ciImage: CIImage) {
        guard !self.isWaitingForUserInput else {
            return
        }
        self.recognizer.recognize(ciImage) { [weak self] results in
            self?.recognizeResults(results)
        }
    }

    private func recognizeResults(_ results: [String]) {
        if results.count == 1 {
            self.didSuccess(results.first!)
        } else if results.count > 1 {
            let controllerItem = makeAlertControllerItem(for: results)
            self.didRecognizeMultipleResults(controllerItem)
        }
    }

    private func makeAlertControllerItem(for extractorResults: [String]) -> AlertControllerViewItem {
        self.isWaitingForUserInput = true
        var actions = extractorResults.map { extractorResult in
            AlertActionViewItem(title: extractorResult, style: .default(isPreferred: false)) { [unowned self] in
                self.didSuccess(extractorResult)
            }
        }

        actions.append(AlertActionViewItem(title: "Cancel", style: .cancel) { [unowned self] in
            self.isWaitingForUserInput = false
        })

        return AlertControllerViewItem(title: "We have found multiple IBANs or emails", message: "Select one", actions: actions)
    }
}
