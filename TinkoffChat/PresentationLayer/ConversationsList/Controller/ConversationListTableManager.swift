//
//  ConversationListTableManager.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.04.2021.
//

import UIKit
import CoreData

protocol ConversationListTableManagerProtocol: UITableViewDataSource, UITableViewDelegate {
    func getConversationForIndexPath(_ indexPath: IndexPath) -> ChannelDb
    func getConversations() -> [ChannelDb]
}

protocol ConversationListTableManagerDelegate: class {
    func didSelectChannel(_ channel: SelectedChannelProtocol)
}

class ConversationListTableManager: NSObject, ConversationListTableManagerProtocol {
    
    let fetchedResultsController: NSFetchedResultsController<ChannelDb>
    
    weak var delegate: ConversationListTableManagerDelegate?
    
    init(fetchedResultsController: NSFetchedResultsController<ChannelDb>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func getConversations() -> [ChannelDb] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    public func getConversationForIndexPath(_ indexPath: IndexPath) -> ChannelDb {
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
            guard let id = channel.identifier else { return }
            NetworkService.shared.deleteChannel(id, completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    CoreDataStack.shared.performDelete { context in
                        context.delete(channel)
                    }
                }
            })
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