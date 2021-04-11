//
//  FileSerializeProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 16.03.2021.
//

import Foundation

protocol FileSerializeProtocol: class {
    associatedtype Model
    
    func serialize(model: Model) -> [String: Any?]
    func deserialize(from data: Data) throws -> Model?
}
