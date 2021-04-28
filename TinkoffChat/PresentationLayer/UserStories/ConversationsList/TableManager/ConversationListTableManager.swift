//
//  ConversationListTableManager.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.04.2021.
//

import UIKit
import CoreData

protocol ConversationListTableManagerDelegate: AnyObject {
    func didSelectChannel(_ channel: SelectedChannelProtocol)
    func didRemoveChannel(_ channel: Channel)
}

class ConversationListTableManager: NSObject, ConversationListTableManagerProtocol {
    
    let fetchedResultsController: NSFetchedResultsController<Channel>
    
    weak var delegate: ConversationListTableManagerDelegate?
    
    init(fetchedResultsController: NSFetchedResultsController<Channel>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func getConversations() -> [Channel] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    public func getConversationForIndexPath(_ indexPath: IndexPath) -> Channel {
        return fetchedResultsController.object(at: indexPath)
    }
}

extension ConversationListTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsListTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ConversationsListTableViewCell else {
            fatalError("dequeueReusableCell ConversationsListTableViewCell not found")
        }
        cell.configureCell(model: conversation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultsController.object(at: indexPath)
            delegate?.didRemoveChannel(channel)
        }
    }
}

extension ConversationListTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = getConversationForIndexPath(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let name = conversation.name, let id = conversation.identifier else { return }
        delegate?.didSelectChannel(SelectedChannel(name: name, id: id))
    }
}
