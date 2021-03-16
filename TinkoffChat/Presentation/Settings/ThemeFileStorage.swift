//
//  ThemeFileStorage.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 15.03.2021.
//

import UIKit

protocol ThemeStorageProtocol {
    func save(userTheme: UserSettings, completionHandler: @escaping (_ success: Bool) -> Void )
    func load(completionHandler: @escaping (_ userTheme: UserSettings?) -> Void)
}

class ThemeFileStorage {
    
    private let fileManager: FileManager
    private let filePath: URL?
    
    init() {
        fileManager = FileManager.default
        filePath = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask).first?.appendingPathComponent(Constants.userThemeFileName)
    }
}

extension ThemeFileStorage: ThemeStorageProtocol {
    
    public func load(completionHandler: @escaping (_ userTheme: UserSettings?) -> Void) {
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
            let userTheme = try deserialize(from: data)
            completionHandler(userTheme)
            return
        } catch {
            print("Error loading data from file \(error)")
        }
        completionHandler(nil)
    }
    
    public func save(userTheme: UserSettings, completionHandler: @escaping (_ success: Bool) -> Void) {
        let dataDictionary = serialize(model: userTheme)
        
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

extension ThemeFileStorage: SerializeFileProtocol {
    
    func serialize(model userTheme: UserSettings) -> [String: Any?] {
        
        return [Constants.userThemeKey: userTheme.currentTheme]
    }
    
    func deserialize(from data: Data) throws -> UserSettings? {
        
        do {
            if let dictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: Any] {
                let currentTheme = dictionary[Constants.userThemeKey] as? String

                return UserSettings(currentTheme: currentTheme)
            }
        } catch {
            print("Deserialize Error \(error)")
        }
        return nil
    }
}
