//
//  UserDefaultsMock.swift
//  TinkoffChatTests
//
//  Created by Dmitry Kulagin on 03.05.2021.
//

@testable import TinkoffChat
import Foundation

final class UserDefaultsMock: UserDefaultsCoreProtocol {
    var saveCallsCount = 0
    var readCallsCount = 0
    
    func getValueToKey(key: String, completion: @escaping (String?) -> Void) {
        readCallsCount += 1
        completion(nil)
    }
    
    func getValueToKey(key: String) -> String? {
        readCallsCount += 1
        return nil
    }
    
    func setValueToKey(value: String, key: String) {
        saveCallsCount += 1
    }
}
