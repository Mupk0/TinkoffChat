//
//  ConversationTableManager.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 07.04.2021.
//

import UIKit
import CoreData

class ConversationTableManager: NSObject, ConversationTableManagerProtocol {
    
    let fetchedResultsController: NSFetchedResultsController<Message>
    
    var deviceId: String?
    
    init(fetchedResultsController: NSFetchedResultsController<Message>) {
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func getMessages() -> [Message] {
        return fetchedResultsController.fetchedObjects ?? []
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
        let message = fetchedResultsController.object(at: indexPath)
        
        let identifier = message.senderId == deviceId
            ? OutgoingMessageTableViewCell.reuseIdentifier
            : IncomingMessageTableViewCell.reuseIdentifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                       for: indexPath) as? MessageCellProtocol & UITableViewCell
        else { fatalError("Wrong Cell Type") }
        cell.setMessageModel(message)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
}
