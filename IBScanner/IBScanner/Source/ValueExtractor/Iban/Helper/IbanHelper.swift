//
//  IbanHelper.swift
//  TomorrowIbanScanner
//
//  Created by Sasha Kravchenko on 14.02.19.
//  Copyright © 2019 Tomorrow GmbH. All rights reserved.
//

enum IbanHelper {

    private static let ibanRegex = "\\A[A-Z]{2}\\d{2}[A-Z\\d]+\\z"

    static func isValid(iban: String) -> Bool {
        guard isValidLength(iban: iban) else {
            return false
        }

        guard iban.range(of: self.ibanRegex, options: .regularExpression) != nil else {
            return false
        }

        return isValidChecksum(iban: iban)
    }

    private static func isValidChecksum(iban: String) -> Bool {
        let chars = iban.map { $0 }
        let adjustedIban = chars.dropFirst(4) + chars.prefix(4)

        let mod = adjustedIban.reduce(0) { previousMod, char in
            let value = Int(String(char), radix: 36)! // "0" => 0, "A" => 10, "Z" => 35
            let factor = value < 10 ? 10 : 100
            return (factor * previousMod + value) % 97
        }

        return mod == 1
    }

    private static func isValidLength(iban: String) -> Bool {
        guard let country = CountryIso(rawValue: String(iban.prefix(2))) else {
            return false
        }

        return iban.count == length(for: country)
    }
}
