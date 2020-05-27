//
//  IbanHelper.swift
//  TomorrowIbanScanner
//
//  Created by Alexander Kravchenko on 14.02.19.
//  Copyright © 2019 ToMoRRoW GmbH. All rights reserved.
//

enum IbanHelper {

    public static let minIbanLength = 15

    private static let ibanRegex = "\\A[A-Z]{2}\\d{2}[A-Z\\d]+\\z"

    public static func make(from string: String) -> Iban? {
        let ibanValue = trimNonValidCharacters(from: string.uppercased())
        guard isValid(iban: ibanValue) else {
            return nil
        }

        return Iban(value: ibanValue)
    }

    public static func trimNonValidCharacters(from string: String) -> String {
        string.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
    }

    private static func isValid(iban: String) -> Bool {
        guard iban.count >= self.minIbanLength else {
            return false
        }

        guard iban.range(of: IbanHelper.ibanRegex, options: .regularExpression) != nil else {
            return false
        }

        guard isValidLength(iban: iban) else {
            return false
        }

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

        if let length = ibanLength(for: country) {
            return iban.count == length
        } else {
            return false
        }
    }
}
