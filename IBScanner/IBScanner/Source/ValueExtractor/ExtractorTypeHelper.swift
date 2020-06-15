//
//  ExtractorTypeHelper.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 22.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

@available(iOS 13, *)
enum ExtractorTypeHelper {
    static func trackingName(type: ExtractorValue) -> String {
        switch type {
        case .iban:
            return "contact_iban"
        case .email:
            return "contact_email"
        }
    }
}
