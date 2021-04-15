//
//  ConversationsListDataModelProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import Foundation
import CoreData

protocol ConversationsListDataModelProtocol {
    var delegate: ConversListModelDelegate? { get set }
    
    func fetchChannels()
    func removeChannel(channel: Channel)
    func createNewChannel(name: String)
    
    func getFetchedRequestController() -> NSFetchedResultsController<Channel>
}
