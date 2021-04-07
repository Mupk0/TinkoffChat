//
//  ConversationListTableViewDataSource.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.04.2021.
//

import UIKit
import CoreData

protocol ConversationListTableViewDataSourceProtocol: UITableViewDataSource {
    func getConversationForIndexPath(_ indexPath: IndexPath) -> ChannelDb
}

class ConversationListTableViewDataSource: NSObject, ConversationListTableViewDataSourceProtocol {
    
    let fetchedResultsController: NSFetchedResultsController<ChannelDb>
    
    init(fetchedResultsController: NSFetchedResultsController<ChannelDb>) {
        
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    public func getConversationForIndexPath(_ indexPath: IndexPath) -> ChannelDb {
        return fetchedResultsController.object(at: indexPath)
    }
    
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
}
