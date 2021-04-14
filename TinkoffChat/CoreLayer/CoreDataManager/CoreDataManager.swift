//
//  CoreDataStorage.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import CoreData

class CoreDataManager: CoreDataManagerProtocol {
    
    private let coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    public func getContext() -> NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    func addChannel(id identifier: String, name: String, message: String?, date: Date?) {
        let channelFetchRequest: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        channelFetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        
        coreDataStack.saveContext.perform {
            do {
                let result = try self.coreDataStack.saveContext.fetch(channelFetchRequest)
                let channel = result.first
                
                if channel == nil {
                    let channel = ChannelDb(context: self.coreDataStack.saveContext)
                    channel.identifier = identifier
                    channel.name = name
                    channel.lastActivity = date
                    channel.lastMessage = message
                    self.coreDataStack.performSave()
                } else {
                    self.updateChannel(id: identifier,
                                       name: name,
                                       message: message,
                                       date: date)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateChannel(id identifier: String, name: String, message: String?, date: Date?) {
        let fetchRequest: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        
        coreDataStack.saveContext.perform {
            do {
                let result = try self.coreDataStack.saveContext.fetch(fetchRequest)
                if let channel = result.first {
                    if channel.value(forKey: "name") as? String != name {
                        channel.setValue(name, forKey: "name")
                    }
                    
                    if channel.value(forKey: "lastMessage") as? String != message {
                        channel.setValue(message, forKey: "lastMessage")
                    }
                    
                    if channel.value(forKey: "lastActivity") as? Date != date {
                        channel.setValue(date, forKey: "lastActivity")
                    }
                    self.coreDataStack.performSave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteChannel(channelId: String) {
        let fetchRequest: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        coreDataStack.saveContext.perform {
            do {
                let result = try self.coreDataStack.saveContext.fetch(fetchRequest)
                if let channel = result.first {
                    self.coreDataStack.saveContext.delete(channel)
                    
                    do {
                        try self.coreDataStack.saveContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addMessage(channelId: String,
                    messageId: String,
                    senderId: String,
                    senderName: String,
                    content: String,
                    created: Date) {
        
        let channelFetchRequest: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        channelFetchRequest.predicate = NSPredicate(format: "identifier = %@", channelId)
        
        let messageFetchRequest: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        let messagePredicate = NSPredicate(format: "identifier = %@", messageId)
        messageFetchRequest.predicate = messagePredicate
        
        coreDataStack.saveContext.perform {
            do {
                let message = try self.coreDataStack.saveContext.fetch(messageFetchRequest)
                let result = try self.coreDataStack.saveContext.fetch(channelFetchRequest)
                if let channel = result.first,
                   message.first == nil {
                    let newMessage = MessageDb(context: self.coreDataStack.saveContext)
                    newMessage.identifier = messageId
                    newMessage.senderId = senderId
                    newMessage.senderName = senderName
                    newMessage.content = content
                    newMessage.created = created
                    channel.addToMessages(newMessage)
                    self.coreDataStack.performSave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
