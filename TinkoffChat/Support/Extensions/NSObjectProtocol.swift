//
//  NSObjectProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 13.02.2021.
//

import Foundation

extension NSObjectProtocol {

    var className: String {
        return String(describing: Self.self)
    }
}
