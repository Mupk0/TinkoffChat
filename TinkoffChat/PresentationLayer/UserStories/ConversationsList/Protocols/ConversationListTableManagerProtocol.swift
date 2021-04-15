//
//  ConversationListTableManagerProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.04.2021.
//

import UIKit
import CoreData

protocol ConversationListTableManagerProtocol: UITableViewDataSource, UITableViewDelegate {
    var fetchedResultsController: NSFetchedResultsController<Channel> { get }
    
    func getConversationForIndexPath(_ indexPath: IndexPath) -> Channel
    func getConversations() -> [Channel]
}
