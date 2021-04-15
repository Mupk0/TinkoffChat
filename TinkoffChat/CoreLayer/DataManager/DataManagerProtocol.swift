//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

protocol DataManagerProtocol {
    func save<T: Codable>(_ object: T,
                          to fileName: String,
                          completionHandler: @escaping (Error?) -> Void)
    func load<T: Codable>(_ type: T.Type,
                          from fileName: String,
                          completionHandler: @escaping (T?, Error?) -> Void)
}
