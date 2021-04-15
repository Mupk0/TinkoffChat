//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Dmitry Kulagin on 14.04.2021.
//

import Foundation

class DataManager: DataManagerProtocol {
    
    private let backgroundQueue = DispatchQueue(label: "ru.tinkoff.TinkoffChat.DataManager",
                                                qos: .userInitiated)
    
    private func createURL(withFileName fileName: String) -> URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName).appendingPathExtension("json")
    }
    
    public func save<T: Codable>(_ object: T,
                                 to fileName: String,
                                 completionHandler: @escaping (Error?) -> Void) {
        backgroundQueue.async {
            do {
                let url = self.createURL(withFileName: fileName)
                let data = try JSONEncoder().encode(object)
                try data.write(to: url, options: .atomic)
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
        }
    }
    
    public func load<T: Codable>(_ type: T.Type,
                                 from fileName: String,
                                 completionHandler: @escaping (T?, Error?) -> Void) {
        backgroundQueue.async {
            do {
                let url = self.createURL(withFileName: fileName)
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(decodedData, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
