//
//  ProfileStorageProtocol.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import Foundation

protocol ProfileStorageProtocol {
    func save(profile: Profile, completionHandler: @escaping (_ success: Bool) -> Void )
    func load(completionHandler: @escaping (_ profile: Profile?) -> Void)
}

protocol SerializeFileProtocol {
    associatedtype Model
    
    func serialize(model: Model) -> [String: Any?]
    func deserialize(from data: Data) throws -> Model?
}
