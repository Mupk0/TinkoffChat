//
//  ConversationDataModelProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation
import CoreData

protocol ConversationDataModelProtocol {
    var delegate: ConversationDataModelDelegate? { get set }
    func fetchMessages(id channelId: String)
    func sendMessage(id channelId: String, text: String)
    func getFetchedRequestController(id channelId: String) -> NSFetchedResultsController<Message>
}
