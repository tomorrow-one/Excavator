//
//  AlertActionViewItem.swift
//  Tomorrow
//
//  Created by Pavel Stepanov on 05.12.19.
//  Copyright © 2019 Tomorrow GmbH. All rights reserved.
//

struct AlertActionViewItem {
    let title: String
    let style: Style
    let action: () -> Void
}

extension AlertActionViewItem {
    enum Style {
        case `default`(isPreferred: Bool), destructive, cancel
    }
}
