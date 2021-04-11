//
//  ConversationsListType.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.02.2021.
//

import Foundation

enum ConversationsListType: Int, CaseIterable {
    case online
    case offline
    
    func getTitle() -> String {
        switch self {
        case .online:
            return "Online"
        case .offline:
            return "History"
        }
    }
}
