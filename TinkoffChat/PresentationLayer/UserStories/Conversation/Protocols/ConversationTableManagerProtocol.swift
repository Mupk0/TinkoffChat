//
//  ConversationTableManagerProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import UIKit

protocol ConversationTableManagerProtocol: UITableViewDataSource {
    func getMessages() -> [Message]
}
