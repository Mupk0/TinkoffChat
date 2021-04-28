//
//  ConversationsListDataModel.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation
import CoreData

protocol ConversListModelDelegate: AnyObject {
    func loadComplited()
}

class ConversationsListDataModel: ConversationsListDataModelProtocol {
    
    weak var delegate: ConversListModelDelegate?
    
    let firebaseService: FirebaseServiceProtocol
    let coreDataService: CoreDataManagerProtocol
    
    init(firebaseService: FirebaseServiceProtocol,
         coreDataService: CoreDataManagerProtocol) {
        self.firebaseService = firebaseService
        self.coreDataService = coreDataService
    }
    
    func fetchChannels() {
        firebaseService.getChannels {
            self.delegate?.loadComplited()
        }
    }
    
    func removeChannel(channel: Channel) {
        firebaseService.deleteChannel(channel)
    }
    
    func createNewChannel(name: String) {
        firebaseService.createChannel(channelName: name)
    }
    
    func getFetchedRequestController() -> NSFetchedResultsController<Channel> {
        let request: NSFetchRequest<Channel> = Channel.fetchRequest()
        let sortActivityDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sortNameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortActivityDescriptor, sortNameDescriptor]
        
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: coreDataService.getContext(),
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
}
