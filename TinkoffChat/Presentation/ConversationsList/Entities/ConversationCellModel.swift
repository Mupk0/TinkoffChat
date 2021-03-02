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

extension Array where Element == ConversationCellModel {
    
    func getOnline() -> [ConversationCellModel] {
        return self.filter{ $0.online }
    }
    
    func getOffline() -> [ConversationCellModel] {
        return self.filter{ !$0.online }
    }
}
