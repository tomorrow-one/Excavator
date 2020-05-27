//
//  ExtractorValueType.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
public enum ExtractorValue {
    case iban(iban: Iban)
    case email(email: String)
}
