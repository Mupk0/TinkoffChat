//
//  CoreDataStackProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import CoreData

protocol CoreDataStackProtocol {
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
    
    func performSave()
    func performSave(completion: (() -> Void)?)
    func performSave(with context: NSManagedObjectContext)
    func performSave(with context: NSManagedObjectContext, completion: (() -> Void)?)
}
