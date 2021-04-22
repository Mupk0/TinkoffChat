//
//  ParserProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 22.04.2021.
//

import Foundation

protocol ParserProtocol {
    associatedtype Model
    func parse(data: Data) -> Model?
}
