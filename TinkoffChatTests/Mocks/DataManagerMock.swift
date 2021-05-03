//
//  DataManagerMock.swift
//  TinkoffChatTests
//
//  Created by Dmitry Kulagin on 03.05.2021.
//

@testable import TinkoffChat
import UIKit

final class DataManagerMock: DataManagerProtocol {
    var saveCallsCount = 0
    var readCallsCount = 0
    
    func save<T: Codable>(_ object: T,
                          to fileName: String,
                          completionHandler: @escaping (Error?) -> Void) {
        saveCallsCount += 1
    }
    
    func load<T: Codable>(_ type: T.Type,
                          from fileName: String,
                          completionHandler: @escaping (T?, Error?) -> Void) {
        readCallsCount += 1
    }
}
