//
//  FirebaseParser.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation
import Firebase

class FirebaseParser: FirebaseParserProtocol {
    
    private let coreDataService: CoreDataManagerProtocol
    
    init(coreDataService: CoreDataManagerProtocol) {
        self.coreDataService = coreDataService
    }
    
    func parseNewChannel(diff: DocumentChange) {
        let channel = diff.document.data()
        
        guard let name = channel["name"] as? String,
              name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else { return }
        
        let lastMessage = channel["lastMessage"] as? String
        let lastMessageDate = channel["lastActivity"] as? Timestamp
        
        coreDataService.addChannel(id: diff.document.documentID,
                                   name: name,
                                   message: lastMessage,
                                   date: lastMessageDate?.dateValue())
    }
    
    func parseUpdateChannel(diff: DocumentChange) {
        let channel = diff.document.data()
        
        guard let name = channel["name"] as? String,
              name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else { return }
        
        let lastMessage = channel["lastMessage"] as? String
        let lastMessageDate = channel["lastActivity"] as? Timestamp
        
        coreDataService.updateChannel(id: diff.document.documentID,
                                      name: name,
                                      message: lastMessage,
                                      date: lastMessageDate?.dateValue())
    }
    
    func parseNewMessage(channelId: String, diff: DocumentChange) {
        let message = diff.document.data()
        
        guard let content = message["content"] as? String,
              let senderId = message["senderId"] as? String,
              let senderName = message["senderName"] as? String,
              let created = message["created"] as? Timestamp,
              content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
              senderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else { return }
        
        coreDataService.addMessage(channelId: channelId,
                                   messageId: diff.document.documentID,
                                   senderId: senderId,
                                   senderName: senderName,
                                   content: content,
                                   created: created.dateValue())
    }
}
