//
//  Message.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 01.03.2021.
//

import Foundation

struct Message: MessageCellConfiguration {
    let content: String?
    let created: Date?
    let senderId: String?
    let senderName: String?
}
