//
//  EmailExtractor.swift
//  Excavator
//
//  Created by Pavel Stepanov on 23.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public final class EmailExtractor: ValueExtracting {

    private let minConfidence: Float
    private let validator = EmailValidator()

    public init(minConfidence: Float = 0.5) {
        self.minConfidence = minConfidence
    }

    public func extract(from input: [TextRecognizer.Result]) -> [String] {
        input
            .filter { $0.confidence >= self.minConfidence }
            .map { $0.value }
            .compactMap(process(input:))
    }

    private func process(input: String) -> String? {
        guard let atSymbolPosition = input.firstIndex(of: "@") else {
            return nil
        }
        let prefix = self.prefix(atSymbolPosition: atSymbolPosition, input: input)
        let result = suffix(atSymbolPosition: atSymbolPosition, input: input, intermediateResult: prefix)
        return self.validator.isValid(email: result) ? result : nil
    }

    private func prefix(atSymbolPosition: String.Index, input: String) -> String {
        var result = ""
        var offsetBackward = atSymbolPosition.utf16Offset(in: input)
        while offsetBackward > 0 {
            let startIndex = input.index(input.startIndex, offsetBy: offsetBackward - 1)
            let endIndex = input.index(input.startIndex, offsetBy: offsetBackward)

            var previousCharacterSubstring = input[startIndex..<endIndex]
            let previousCharacter = previousCharacterSubstring.popFirst()!

            if self.validator.isValid(character: previousCharacter) {
                result.insert(previousCharacter, at: result.startIndex)
                offsetBackward -= 1
            } else {
                break
            }
        }
        return result
    }

    private func suffix(atSymbolPosition: String.Index, input: String, intermediateResult: String) -> String {
        var result = intermediateResult
        var offsetForward = atSymbolPosition.utf16Offset(in: input)
        while offsetForward < input.count {
            let startIndex = input.index(input.startIndex, offsetBy: offsetForward)
            let endIndex = input.index(input.startIndex, offsetBy: offsetForward + 1)

            var nextCharacterSubstring = input[startIndex..<endIndex]
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

