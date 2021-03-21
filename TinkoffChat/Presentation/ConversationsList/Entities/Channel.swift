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

extension Channel: Equatable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
    }
}

extension Channel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(name)
    }
}

extension Array where Element == Channel {
    func getUniqueValues() -> [Channel] {
        return Array(Set(self))
    }
    
    func sort() -> [Channel] {
        var result = self.getUniqueValues()
        result.sort { (first, second) -> Bool in
            guard let firstDate = first.lastActivity else { return false }
            guard let secondDate = second.lastActivity else { return true }
            return firstDate > secondDate
        }
        return result
    }
}
