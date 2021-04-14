//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 28.03.2021.
//

import Foundation
import CoreData

class CoreDataStack: CoreDataStackProtocol {
    
    static let shared = CoreDataStack()
    
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
    
    lazy var writterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistantStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private(set) lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writterContext
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    func performSave() {
        performSave(with: saveContext)
    }
    
    func performSave(completion: (() -> Void)?) {
        performSave(with: saveContext, completion: completion)
    }
    
    func performSave(with context: NSManagedObjectContext) {
        performSave(with: context, completion: nil)
    }
    
    func performSave(with context: NSManagedObjectContext, completion: (() -> Void)?) {
        context.perform {
            guard context.hasChanges else {
                completion?()
                return
            }
            
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
            
            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
            } else {
                completion?()
            }
        }
    }
}
