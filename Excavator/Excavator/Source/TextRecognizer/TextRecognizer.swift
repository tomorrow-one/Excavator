//
//  TextRecognizer.swift
//  Excavator
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

    public func recognize(in image: CIImage, completion: @escaping ([String]) -> Void) {
        guard !self.inProgress else {
            return
        }

        self.inProgress = true
        self.queue.async { [unowned self] in
            do {
                let request = self.makeRequest { [weak self] rawResult in
                    self?.inProgress = false
                    guard !rawResult.isEmpty else {
                        return
                    }
                    guard let result = self?.extractor.extract(from: rawResult), !result.isEmpty else {
                        return
                    }
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                let handler = VNImageRequestHandler(ciImage: image)
                try handler.perform([request])
            } catch {
                self.inProgress = false
                self.log(error: error)
            }
        }
    }

    private func makeRequest(completion: @escaping ([TextRecognizer.Result]) -> Void) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                self?.log(error: error)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                preconditionFailure("observations must be of type \(type(of: VNRecognizedTextObservation.self))")
            }

            let result = observations
                .compactMap { $0.topCandidates(1).first }
                .map { TextRecognizer.Result(value: $0.string, confidence: $0.confidence) }

            completion(result)
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        return request
    }

    private func log(error: Error) {
        guard TextRecognizer.Config.isDebugLoggingEnabled else {
            return
        }

        debugPrint(error.localizedDescription)
    }
}
