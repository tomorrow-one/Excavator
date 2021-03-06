//
//  TextRecognizing.swift
//  Excavator
//
//  Created by Pavel Stepanov on 21.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import UIKit

@available(iOS 13, *)
public protocol TextRecognizing: class {
    var inProgress: Bool { get set }
    func recognize(in image: CIImage, completion: @escaping ([String]) -> Void)
}
