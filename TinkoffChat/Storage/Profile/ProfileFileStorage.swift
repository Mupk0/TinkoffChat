//
//  ProfileFileStorage.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//

import UIKit

protocol ProfileStorageProtocol: class {
    func save(_ profile: Profile, completionHandler: @escaping (_ success: Bool) -> Void)
    func load(completionHandler: @escaping (_ model: Profile?) -> Void)
}

class ProfileFileStorage {
    
    private let fileManager: FileManager
    private let filePath: URL?
    
    init() {
        fileManager = FileManager.default
        filePath = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask).first?.appendingPathComponent(Constants.profileFileName)
    }
}

extension ProfileFileStorage: ProfileStorageProtocol {
    
    public func load(completionHandler: @escaping (_ profile: Profile?) -> Void) {
        guard let filePath = filePath else {
            print("Error With Url Path")
            completionHandler(nil)
            return
        }
        guard fileManager.fileExists(atPath: filePath.path) else {
            completionHandler(nil)
            return
        }
        do {
            let data = try Data(contentsOf: filePath)
            let profile = try deserialize(from: data)
            completionHandler(profile)
            return
        } catch {
            print("Error loading data from file \(error)")
        }
        completionHandler(nil)
    }
    
    public func save(_ profile: Profile, completionHandler: @escaping (_ success: Bool) -> Void) {
        let dataDictionary = serialize(model: profile)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dataDictionary,
                                                        requiringSecureCoding: false)
            guard let filePath = filePath else {
                print("Error With Url Path")
                completionHandler(false)
                return
            }
            
            try data.write(to: filePath)
            completionHandler(true)
            return
        } catch {
            print("Error writing data \(error)")
        }
        completionHandler(false)
    }
}

extension ProfileFileStorage: FileSerializeProtocol {
    
    func serialize(model: Profile) -> [String: Any?] {
        
        var userPhotoData: Data?
        if let userPhoto = model.photo {
            do {
                userPhotoData = try NSKeyedArchiver.archivedData(withRootObject: userPhoto,
                                                                 requiringSecureCoding: false)
            } catch {
                print("Serialize Error \(error)")
            }
        }
        
        return [Constants.profileUserPhotoKey: userPhotoData,
                Constants.profileUserNameKey: model.userName,
                Constants.profileUserDescriptionKey: model.about]
    }
    
    func deserialize(from data: Data) throws -> Profile? {
        
        do {
            if let dictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] {
                let name = dictionary[Constants.profileUserNameKey] as? String
                let userDescription = dictionary[Constants.profileUserDescriptionKey] as? String
                
                var userPhoto: UIImage?
                
                if let userPhotoData = dictionary[Constants.profileUserPhotoKey] as? Data {
                    userPhoto = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userPhotoData) as? UIImage
                }
                return Profile(about: userDescription, photo: userPhoto, userName: name)
            }
        } catch {
            print("Deserialize Error \(error)")
        }
        return nil
    }
}
