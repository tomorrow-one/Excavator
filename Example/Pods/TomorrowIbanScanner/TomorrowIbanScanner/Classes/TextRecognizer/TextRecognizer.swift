//
//  TextRecognizer.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 15.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import Vision

@available(iOS 13, *)
public final class TextRecognizer: TextRecognizing {

    public var inProgress = false

    private let textRecognitionWorkQueue = DispatchQueue.global(qos: .userInitiated)

    public init() { }

    public func recognizeTextInImage(_ ciImage: CIImage, completion: @escaping ([TextRecognizerResult]) -> Void) {
        guard !self.inProgress else {
            return
        }
        self.inProgress = true
        let request = makeRequest(completion: completion)
        self.textRecognitionWorkQueue.async {
            do {
                let requestHandler = VNImageRequestHandler(ciImage: ciImage)
                try requestHandler.perform([request])
            } catch {
                self.logError(error: error)
            }
        }
    }

    private func makeRequest(completion: @escaping ([TextRecognizerResult]) -> Void) -> VNRecognizeTextRequest {
        let textRecognitionRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else {
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                if let error = error {
                    self.logError(error: error)
                }
                return
            }

            let result = observations
                .compactMap { $0.topCandidates(1).first }
                .map { TextRecognizerResult(value: $0.string, confidence: $0.confidence) }

            DispatchQueue.main.async {
                self.inProgress = false
                completion(result)
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        return textRecognitionRequest
    }

    private func logError(error: Error) {
        if TextRecognizerConfig.isDebugLoggingEnabled {
            debugPrint(error.localizedDescription)
        }
    }
}
