//
//  UserDefaultsCoreProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation

protocol UserDefaultsCoreProtocol {
    func getValueToKey(key: String, completion: @escaping (String?) -> Void)
    func getValueToKey(key: String) -> String?
    func setValueToKey(value: String, key: String)
}
