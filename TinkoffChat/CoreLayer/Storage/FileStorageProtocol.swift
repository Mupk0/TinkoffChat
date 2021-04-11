//
//  FileStorageProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 11.04.2021.
//

import Foundation

protocol FileStorageProtocol: class {
    associatedtype Model
    
    func save(model: Model, completionHandler: @escaping (_ success: Bool) -> Void)
    func load(completionHandler: @escaping (_ model: Model?) -> Void)
}
