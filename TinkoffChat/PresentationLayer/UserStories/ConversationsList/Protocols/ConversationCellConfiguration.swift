//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 02.03.2021.
//

import Foundation

protocol ConversationCellConfiguration {
    var name: String? { get set }
    var lastMessage: String? { get set }
    var lastActivity: Date? { get set }
}
