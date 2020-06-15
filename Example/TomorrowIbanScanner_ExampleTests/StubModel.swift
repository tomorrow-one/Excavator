//
//  StubModel.swift
//  TomorrowIbanScannerTests
//
//  Created by Pavel Stepanov on 15.05.20.
//  Copyright © 2020 Pavel Stepanov. All rights reserved.
//

@testable import IBScanner

enum StubModel {
    static let validIban = Iban(value: "DE75110101002144403897")
    static let validIban2 = Iban(value: "DE34110101002851109678")
}
