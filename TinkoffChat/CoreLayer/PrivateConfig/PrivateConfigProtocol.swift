//
//  PrivateConfigProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 12.05.2021.
//

import Foundation

protocol PrivateConfigProtocol {
    func getValueForProperties(_ properties: PrivateProperties) -> String?
}
