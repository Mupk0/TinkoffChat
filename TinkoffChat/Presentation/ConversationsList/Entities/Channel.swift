//
//  Channel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import Foundation

struct Channel: ConversationCellConfiguration {
    let identifier: String
    var name: String?
    var lastMessage: String?
    var lastActivity: Date?
}
