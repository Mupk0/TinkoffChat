//
//  SelectedChannel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 09.04.2021.
//

import Foundation

protocol SelectedChannelProtocol {
    var name: String { get }
    var id: String { get }
}

struct SelectedChannel: SelectedChannelProtocol {
    let name: String
    let id: String
}
