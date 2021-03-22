//
//  MessageCellConfiguration.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 02.03.2021.
//

import Foundation

protocol MessageCellConfiguration {
    var content: String { get }
    var created: Date { get }
    var senderId: String { get }
    var senderName: String { get }
}
