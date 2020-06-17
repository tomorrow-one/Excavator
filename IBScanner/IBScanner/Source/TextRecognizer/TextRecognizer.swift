//
//  TextRecognizer.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 15.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import UIKit
import Vision

@available(iOS 13, *)
public final class TextRecognizer: TextRecognizing {

    public var inProgress = false

    private let extractor: ValueExtracting
    private let queue = DispatchQueue.global(qos: .userInitiated)

    public init(extractor: ValueExtracting) {
        self.extractor = extractor
    }

    public func recognize(_ ciImage: CIImage, completion: @escaping ([String]) -> Void) {
        guard !self.inProgress else {
            return
        }

        self.inProgress = true
        self.queue.async { [unowned self] in
            do {
                let request = self.makeRequest { [weak self] results in
                    self?.inProgress = false
                    guard let strings = self?.extractor.extract(from: results), !strings.isEmpty else {
                        return
                    }
                    completion(strings)
                }
                let handler = VNImageRequestHandler(ciImage: ciImage)
                try handler.perform([request])
            } catch {
                self.inProgress = false
                self.logError(error: error)
            }
        }
    }

    private func makeRequest(completion: @escaping ([TextRecognizerResult]) -> Void) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                if let error = error {
                    self?.logError(error: error)
                }
                return
            }

            let result = observations
                .compactMap { $0.topCandidates(1).first }
                .map { TextRecognizerResult(value: $0.string, confidence: $0.confidence) }

            DispatchQueue.main.async {
                completion(result)
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        return request
    }

    private func logError(error: Error) {
        if TextRecognizerConfig.isDebugLoggingEnabled {
            debugPrint(error.localizedDescription)
        }
    }
}
