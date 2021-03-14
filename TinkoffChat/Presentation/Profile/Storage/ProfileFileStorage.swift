//
//  ProfileFileStorage.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.03.2021.
//


import UIKit

final class ProfileFileStorage: ProfileStorageProtocol {
    
    private let fileManager = FileManager.default
    
    private func getFilePath() -> URL? {
        return fileManager.urls(for: .documentDirectory,
                                in: .userDomainMask).first?.appendingPathComponent(Constants.profileFileName)
    }
    
    public func load(completionHandler: @escaping (_ profile: Profile?) -> Void) {
        guard let filePath = getFilePath(), fileManager.fileExists(atPath: filePath.path) else {
            completionHandler(nil)
            return
        }
        do {
            if let filePath = getFilePath() {
                let data = try Data(contentsOf: filePath)
                let profile = try deserialize(from: data)
                completionHandler(profile)
                return
            } else {
                print("Error from Url Path")
                completionHandler(nil)
                return
            }
        } catch {
            print("Error loading data from file \(error)")
        }
        completionHandler(nil)
    }
    
    public func save(profile: Profile, completionHandler: @escaping (_ success: Bool) -> Void) {
        let dataDictionary = serialize(profile: profile)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dataDictionary, requiringSecureCoding: false)
            if let filePath = getFilePath() {
                try data.write(to: filePath)
                completionHandler(true)
                return
            }
        } catch {
            print("Error writing data \(error)")
        }
        completionHandler(false)
    }
    
    private func serialize(profile: Profile) -> [String: Any?] {
        
        var userPhotoData: Data?
        if let userPhoto = profile.photo {
            do {
                userPhotoData = try NSKeyedArchiver.archivedData(withRootObject: userPhoto, requiringSecureCoding: false)
            } catch {
                print("Serialize Error \(error)")
            }
        }
        
        return [Constants.profileUserPhotoKey: userPhotoData,
                Constants.profileUserNameKey: profile.userName,
                Constants.profileUserDescriptionKey: profile.about]
    }
    
    private func deserialize(from data: Data) throws -> Profile? {
        
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
