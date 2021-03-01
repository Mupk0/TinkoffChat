//
//  ConversationCellModel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import Foundation

struct ConversationCellModel: ConversationCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
}
