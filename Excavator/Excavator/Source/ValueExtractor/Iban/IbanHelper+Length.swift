//
//  IbanHelperLength.swift
//  Excavator
//
//  Created by Sasha Kravchenko on 27.04.20.
//  Copyright © 2020 Tomorrow. All rights reserved.
//

/* More information: https://en.wikipedia.org/wiki/International_Bank_Account_Number */
extension IbanValidator {

    static let minLength = Self.allLengths.min()!
    static let maxLength = Self.allLengths.max()!

    private static let allLengths = CountryIso.allKnown.compactMap(length(for:))
    
    static func length(for iso: CountryIso) -> Int? { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch iso {
        case .AL:
            return 28
        case .AD:
            return 24
        case .AT:
            return 20
        case .AZ:
            return 28
        case .BH:
            return 22
        case .BY:
            return 28
        case .BE:
            return 16
        case .BA:
            return 20
        case .BR:
            return 29
        case .BG:
            return 22
        case .CR:
            return 22
        case .HR:
            return 21
        case .CY:
            return 28
        case .CZ:
            return 24
        case .DK:
            return 18
        case .DO:
            return 28
        case .TL:
            return 23
        case .EE:
            return 20
        case .FO:
            return 18
        case .FI:
            return 18
        case .FR:
            return 27
        case .GE:
            return 22
        case .DE:
            return 22
        case .GI:
            return 23
        case .GR:
            return 27
        case .GL:
            return 18
        case .GT:
            return 28
        case .HU:
            return 28
        case .IS:
            return 26
        case .IQ:
            return 23
        case .IE:
            return 22
        case .IL:
            return 23
        case .IT:
            return 27
        case .JO:
            return 30
        case .KZ:
            return 20
        case .XK:
            return 20
        case .KW:
            return 30
        case .LV:
            return 21
        case .LB:
            return 28
        case .LI:
            return 21
        case .LT:
            return 20
        case .LU:
            return 20
        case .MK:
            return 19
        case .MT:
            return 31
        case .MR:
            return 27
        case .MU:
            return 30
        case .MC:
            return 27
        case .MD:
            return 24
        case .ME:
            return 22
        case .NL:
            return 18
        case .NO:
            return 15
        case .PK:
            return 24
        case .PS:
            return 29
        case .PL:
            return 28
        case .PT:
            return 25
        case .QA:
            return 29
        case .RO:
            return 24
        case .LC:
            return 32
        case .SM:
            return 27
        case .SA:
            return 24
        case .RS:
            return 22
        case .SC:
            return 31
        case .SK:
            return 24
        case .SI:
            return 19
        case .ES:
            return 24
        case .SE:
            return 24
        case .CH:
            return 21
        case .TN:
            return 24
        case .TR:
            return 26
        case .UA:
            return 29
        case .AE:
            return 23
        case .GB:
            return 22
        case .VA:
            return 22
        case .VG:
            return 24
        case .DZ:
            return 24
        case .AO:
            return 25
        case .BJ:
            return 28
        case .BF:
            return 28
        case .BI:
            return 16
        case .CM:
            return 27
        case .CV:
            return 25
        case .IR:
            return 26
        case .CI:
            return 28
        case .MG:
            return 27
        case .ML:
            return 28
        case .MZ:
            return 25
        case .SN:
            return 28
        default:
            return nil
        }
    }
}
