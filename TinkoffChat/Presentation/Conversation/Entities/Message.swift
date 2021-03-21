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

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.content == rhs.content
            && lhs.created == rhs.created
            && lhs.senderId == rhs.senderId
            && lhs.senderName == rhs.senderName
    }
}

extension Message: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
        hasher.combine(created)
        hasher.combine(senderId)
        hasher.combine(senderName)
    }
}

extension Array where Element == Message {
    func getUniqueValues() -> [Message] {
        return Array(Set(self))
    }
    
    func sort() -> [Message] {
        var result = self.getUniqueValues()
        result.sort { (first, second) -> Bool in
            guard let firstDate = first.created else { return false }
            guard let secondDate = second.created else { return true }
            return firstDate < secondDate
        }
        return result
    }
}
