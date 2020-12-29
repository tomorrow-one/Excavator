//
//  EmailExtractor.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 23.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public final class EmailExtractor: ValueExtracting {

    private let minConfidence: Float

    private let validator = Validator()

    public init(minConfidence: Float = 0.5) {
        self.minConfidence = minConfidence
    }

    public func extract(from input: [TextRecognizer.Result]) -> [String] {
        input.compactMap { self.process(recognitionResult: $0) }
    }

    private func process(recognitionResult: TextRecognizer.Result) -> String? {
        guard recognitionResult.confidence >= self.minConfidence, let atSymbolPosition = recognitionResult.value.firstIndex(of: "@") else {
                return nil
        }
        let prefix = emailPrefix(atSymbolPosition: atSymbolPosition, recognizedString: recognitionResult.value)
        let result = emailSuffix(atSymbolPosition: atSymbolPosition, recognizedString: recognitionResult.value, intermediateResult: prefix)
        return self.validator.isValid(email: result) ? result : nil
    }

    private func emailPrefix(atSymbolPosition: String.Index, recognizedString: String) -> String {
        var result = ""
        var offsetBackward = atSymbolPosition.utf16Offset(in: recognizedString)
        while offsetBackward > 0 {
            let startIndex = recognizedString.index(recognizedString.startIndex, offsetBy: offsetBackward - 1)
            let endIndex = recognizedString.index(recognizedString.startIndex, offsetBy: offsetBackward)

            var previousCharacterSubstring = recognizedString[startIndex..<endIndex]
            let previousCharacter = previousCharacterSubstring.popFirst()!

            if self.validator.validEmailCharacter(character: previousCharacter) {
                result.insert(previousCharacter, at: result.startIndex)
                offsetBackward -= 1
            } else {
                break
            }
        }
        return result
    }

    private func emailSuffix(atSymbolPosition: String.Index, recognizedString: String, intermediateResult: String) -> String {
        var result = intermediateResult
        var offsetForward = atSymbolPosition.utf16Offset(in: recognizedString)
        while offsetForward < recognizedString.count {
            let startIndex = recognizedString.index(recognizedString.startIndex, offsetBy: offsetForward)
            let endIndex = recognizedString.index(recognizedString.startIndex, offsetBy: offsetForward + 1)

            var nextCharacterSubstring = recognizedString[startIndex..<endIndex]
            let nextCharacter = nextCharacterSubstring.popFirst()!
            if shouldAddNextCharacter(nextCharacter: nextCharacter, intermediateResult: result) {
                result.append(nextCharacter)
                offsetForward += 1
            } else {
                break
            }
        }

        return result
    }

    private func shouldAddNextCharacter(nextCharacter: Character, intermediateResult: String) -> Bool {
        let isAlreadyValid = self.validator.isValid(email: intermediateResult)
        let nextResult = intermediateResult.appending(String(nextCharacter))
        let isNextStepValid = self.validator.isValid(email: nextResult)

        return !isAlreadyValid || isNextStepValid
    }
}

@available(iOS 13, *)
extension EmailExtractor {
    final class Validator {
        private let allowedEmailCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-!#$%&'*+-/=?^_`{|}~;.@"
        private let email = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"# // swiftlint:disable:this line_length
        private lazy var predicateEmail = NSPredicate(format: "SELF MATCHES %@", self.email)

        func validEmailCharacter(character: Character) -> Bool {
            self.allowedEmailCharacters.contains(character)
        }

        func isValid(email: String) -> Bool {
            self.predicateEmail.evaluate(with: email.lowercased())
        }
    }
}
