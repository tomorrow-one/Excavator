//
//  Style.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 15.05.20.
//  Copyright © 2020 Pavel Stepanov. All rights reserved.
//

import UIKit

@available(iOS 13, *)
extension TextRecognizingController {
    public struct Style {
        public let titleFont: UIFont
        public let messageFont: UIFont
        public let borderColor: UIColor

        public init (titleFont: UIFont, messageFont: UIFont, borderColor: UIColor) {
            self.titleFont = titleFont
            self.messageFont = messageFont
            self.borderColor = borderColor
        }
    }
}
