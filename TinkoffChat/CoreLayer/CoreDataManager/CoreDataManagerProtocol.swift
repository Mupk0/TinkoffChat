//
//  CoreDataManagerProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import CoreData

protocol CoreDataManagerProtocol {
    func getContext() -> NSManagedObjectContext
    
    func addChannel(id identifier: String, name: String, message: String?, date: Date?)
    func updateChannel(id identifier: String, name: String, message: String?, date: Date?)
    func deleteChannel(channelId: String)
    func addMessage(channelId: String,
                    messageId: String,
                    senderId: String,
                    senderName: String,
                    content: String,
                    created: Date)
}
