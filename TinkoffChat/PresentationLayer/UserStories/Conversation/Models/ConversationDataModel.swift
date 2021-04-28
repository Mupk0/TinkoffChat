//
//  ConversationDataModel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation
import CoreData

protocol ConversationDataModelDelegate: AnyObject {
    func messageSenden()
}

class ConversationDataModel: ConversationDataModelProtocol {
    
    weak var delegate: ConversationDataModelDelegate?
    
    let firebaseService: FirebaseServiceProtocol
    let coreDataService: CoreDataManagerProtocol
    let settingsService: SettingsServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol,
         coreDataService: CoreDataManagerProtocol,
         settingsService: SettingsServiceProtocol) {
        
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
        self.settingsService = settingsService
    }
    
    func fetchMessages(id channelId: String) {
        firebaseService.getMessages(channelId: channelId) {}
    }
    
    func sendMessage(id channelId: String, text: String) {
        firebaseService.sendMessage(channelId: channelId,
                                    messageText: text,
                                    complition: { [weak self] status in
                                        if status {
                                            self?.delegate?.messageSenden()
                                        }
                                    })
    }
    
    func getFetchedRequestController(id channelId: String) -> NSFetchedResultsController<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "channel.identifier = %@", channelId as String)
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: coreDataService.getContext(),
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
}
