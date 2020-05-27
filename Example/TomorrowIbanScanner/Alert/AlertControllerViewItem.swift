//
//  AlertControllerViewItem.swift
//  Tomorrow
//
//  Created by Pavel Stepanov on 21.01.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import UIKit

struct AlertControllerViewItem {
    let title: String
    let message: String?
    let actions: [AlertActionViewItem]
    let style: UIAlertController.Style

    init(title: String, message: String?, actions: [AlertActionViewItem], style: UIAlertController.Style = .alert) {
        self.title = title
        self.message = message
        self.actions = actions
        self.style = style
    }
}
