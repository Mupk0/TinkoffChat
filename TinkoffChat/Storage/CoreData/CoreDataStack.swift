//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.03.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    var didUpdateDataBase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documentUrl = FileManager.default.urls(for: .documentDirectory,
                                                         in: .userDomainMask).last else {
            fatalError("document path not found")
        }
        return documentUrl.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: dataModelName,
                                             withExtension: dataModelExtension) else {
            fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("managedObjectModel could not created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
       let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return coordinator
    }()
    
    private lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistantStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    public func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    public func performDelete(_ block: (NSManagedObjectContext) -> Void) {
        let context = writterContext
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
    }
    
    public func enableObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: mainContext)
    }
    
    @objc
    private func managedObjectContextObjectsDidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDataBase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            print("Добавлено обьектов: ", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            print("Обновлено обьектов: ", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Удалено обьектов: ", deletes.count)
        }
    }
    
    func printDatabaseStatistice() {
        mainContext.perform {
            do {
                let channelsCount = try self.mainContext.count(for: ChannelDb.fetchRequest())
                print("Всего в БД: \(channelsCount) каналов")
                
                let messagesCount = try self.mainContext.count(for: MessageDb.fetchRequest())
                print("Всего в БД: \(messagesCount) сообщений")
                
                let channels = try self.mainContext.fetch(ChannelDb.fetchRequest()) as? [ChannelDb] ?? []
                channels.forEach {
                    print("В канале: \($0.name ?? "Unknown Chat Name") с идентификатором: \($0.identifier ?? "Unknown Chat Id")")
                    if let channelMessages = $0.messages?.allObjects as? [MessageDb] {
                        print("Кол-во сообщений в данного чата сохраненных в БД: \(channelMessages.count)")
                        channelMessages.forEach {
                            print("Сообщение от: \($0.senderName ?? "Unknown Sender Name") с текстом: \($0.content ?? "Unknown Content")")
                            print("***")
                        }
                    }
                    print("-----")
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension CoreDataStack {
    
    func getFetchedResultController(id: String) -> NSFetchedResultsController<MessageDb> {
        let request: NSFetchRequest<MessageDb> = MessageDb.fetchRequest()
        request.predicate = NSPredicate(format: "channel.identifier = %@", id as String)
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.returnsDistinctResults = true
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: writterContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }
    
    func getFetchedResultController() -> NSFetchedResultsController<ChannelDb> {
        let request: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        let sortActivityDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        let sortNameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortActivityDescriptor, sortNameDescriptor]
        request.returnsDistinctResults = true
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: writterContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }
    
    @objc
    func getChannel(for id: String, with context: NSManagedObjectContext) -> ChannelDb? {
        let fetchChannel: NSFetchRequest<ChannelDb> = ChannelDb.fetchRequest()
        fetchChannel.predicate = NSPredicate(format: "identifier = %@", id as String)
        
        guard let results = try? context.fetch(fetchChannel),
              results.count != 0,
              let channel = results.first else { return nil }
        
        return channel
    }
}
