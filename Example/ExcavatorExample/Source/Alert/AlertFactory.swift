//
//  AlertHelper.swift
//  Tomorrow
//
//  Created by Alexander Kravchenko on 24.05.18.
//  Copyright © 2018 Goodfolio GmbH. All rights reserved.
//

import UIKit

enum AlertFactory {

    static func makeAlertController(item: AlertControllerViewItem) -> UIAlertController {
        let alertController = UIAlertController(title: item.title, message: item.message, preferredStyle: item.style)
        item.actions.forEach { actionItem in
            let style = makeStyle(for: actionItem.style)
            let action = UIAlertAction(title: actionItem.title, style: style) { _ in
                actionItem.action()
            }
            alertController.addAction(action)
            switch actionItem.style {
            case .default(let isPreferred) where isPreferred:
                alertController.preferredAction = action
            case .default, .destructive, .cancel:
                break
            }
        }
        return alertController
    }

    private static func makeStyle(for style: AlertActionViewItem.Style) -> UIAlertAction.Style {
        switch style {
        case .default:
            return .default
        case .cancel:
            return.cancel
        case .destructive:
            return .destructive
        }
    }
}
