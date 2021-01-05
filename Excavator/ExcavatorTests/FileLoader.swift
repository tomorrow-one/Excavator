//
//  FileLoader.swift
//  ExcavatorTests
//
//  Created by Sasha Kravchenko on 29.12.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import XCTest

final class FileLoader {

    private init() { }

    static func string(from fileName: String) -> String? {
        let bundle = Bundle(for: self)
        guard let url = bundle.url(forResource: fileName, withExtension: "") else {
            XCTFail("Missing file")
            return nil
        }

        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Cannot parse json")
            return nil
        }

        return String(data: data, encoding: .utf8)!
    }
}
